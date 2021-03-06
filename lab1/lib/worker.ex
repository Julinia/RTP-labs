defmodule Worker do
  use GenServer

  def start(index) do
    {:ok, pid} = Client.start

    GenServer.start_link(__MODULE__, %{tweets: %{}, tcp: pid}, name: __MODULE__)
  end

  def process(tweet) do
    GenServer.cast(__MODULE__, {:process, tweet})
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  defp get_score(words) do
    Enum.reduce(words, 0, fn word, acc -> Dictionary.get_value(word) + acc end) / (length(words))
  end

  def get_words(tweet) do
    symbols = [".","]", ")", "(", "[", ":", "?", "!", "\"", ","]
    
    String.replace(tweet["message"]["tweet"]["text"], symbols, "")
    |> String.split(" ", trim: true)
  end

  defp compute_score(tweet) do
    if tweet != "{\"message\": panic}" do
      {:ok, tweet} = Poison.decode(tweet)

      score = get_words(tweet)
        |> get_score()

      {tweet, score}
    else
      {nil, nil}
    end
  end

  @impl true
  def handle_cast({:process, tweet}, _) do
    {decoded_tweet, final_score} = compute_score(tweet)

    if final_score do
      Database.save(Map.put(decoded_tweet, "score", final_score))
    end

    Client.send_message(state.tcp, "PUBLISH tweeter " <> Poison.encode!(tweet) <> "\n")

    {:noreply, %{tweet: tweet, tcp: state.tcp}}
  end
end
