defmodule Lab1.Server do

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :chat_room)
  end

  def get_msgs do
    GenServer.call(:chat_room, :get_msgs)
  end

  def add_msg(msg) do
    GenServer.cast(:chat_room, {:add_msg, msg})
  end


# server side
  def init(msgs) do
    {:ok, msgs}
  end

  def handle_call(:get_msgs, _form, msgs) do
    {:reply, msgs, msgs}
  end

  def handle_cast({:add_msg, msg}, msgs) do
    {:noreply, [msg | msgs]}
  end


end