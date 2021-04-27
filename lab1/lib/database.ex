defmodule Database do
  use GenServer

  def start() do
    {:ok, pid} = Mongo.start_link(url: "mongodb://localhost:27017", database: "real-time-programming")
    GenServer.start_link(
      __MODULE__,
      %{mongo: "", tweets: [], ms: :os.system_time(:millisecond)},
      name: __MODULE__
    )
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def save(tweet) do
    IO.inspect(tweet)
    GenServer.cast(__MODULE__, {:save, tweet})
  end


 @impl true
  def handle_cast({:save, tweet}, state) do
    if should_write(state, 128, 200) do
      Mongo.insert_many(state.mongo, "tweets", state.tweets)
    IO.inspect(state.tweets)

      {:noreply,
       %{
         mongo: state.mongo,
         tweets: [],
         ms: :os.system_time(:millisecond)
       }}
    else
      {:noreply,
       %{
         mongo: state.mongo,
         tweets: state.tweets ++ [tweet],
         ms: state.ms
       }}
    end
  end

  defp should_write(state, size_threshold, time_threshold) do
    cond do
      length(state.tweets) < size_threshold -> false
      :os.system_time(:millisecond) - state.ms < time_threshold -> false
      true -> true
    end
  end
end