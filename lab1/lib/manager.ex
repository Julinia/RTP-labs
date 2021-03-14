defmodule Manager do
  use GenServer

  def start() do
    children = [
      Worker.start(0),
      Worker.start(1),
      Worker.start(2),
      Worker.start(3),
      Worker.start(4)
    ]

    GenServer.start_link(__MODULE__, %{index: 0, children: children}, name: __MODULE__)
  end

  def manage(tweet) do
    GenServer.cast(__MODULE__, {:manage, tweet.data})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:manage, tweet}, state) do
    
    {_, pid} = Enum.at(state.children, rem(state.index, length(state.children)))
    GenServer.cast(pid, {:process, tweet})

    {:noreply, %{index: state.index + 1 , children: state.children}}
  end
end