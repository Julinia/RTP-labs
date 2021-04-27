defmodule Database do
  use GenServer

  def start() do
    {:ok, pid} = Mongo.start_link(url: "mongodb://localhost:27017", database: "real-time-programming")
    GenServer.start_link(
      __MODULE__,
      %{mongo: pid, tweets: []},
      name: __MODULE__
    )
  end

@impl true
  def handle_info(:tick, state) do
    insert(state.tweets)
    {:noreply,
    %{
        mongo: state.mongo,
        tweets: []
    }}
  end

@impl true
  def init(state) do
    :timer.send_interval(200, :tick)
    {:ok, state}
  end

  def save(tweet) do
    GenServer.cast(__MODULE__, {:save, tweet})
  end

  def insert(tweets) do
    # IO.inspect(tweets)
    Mongo.insert_many(state.mongo, "tweets",tweets)
  end

 @impl true
  def handle_cast({:save, tweet}, state) do
    if should_write(state, 128) do
        insert(state.tweets)
        {:noreply,
        %{
            mongo: state.mongo,
            tweets: []
        }}
    else 
        {:noreply,
        %{
            mongo: state.mongo,
            tweets: state.tweets ++ [tweet]
        }}
    end
  end

  defp should_write(state, size_threshold) do
    cond do
      length(state.tweets) < size_threshold -> false
      true -> true
    end
  end
end