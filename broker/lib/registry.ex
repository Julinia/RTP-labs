defmodule Registry do
  use GenServer

  def start() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def add_subs(subject, subscriber) do
    GenServer.cast(__MODULE__, {:add, subject, subscriber})
  end

  def get_by_subject(subject) do
    GenServer.call(__MODULE__, {:get_by_subject, subject})
  end

  @impl true
  def handle_cast({:add, subject, subscriber}, state) do
    {:noreply, [%{subject: subject, subscriber: subscriber} | state]}
  end

  @impl true
  def handle_call({:get_by_subject, subject}, _from, state) do
    {:reply, Enum.filter(state, fn map -> map.subject == subject end), state}
  end
end