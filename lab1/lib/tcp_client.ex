defmodule Client do
  require Logger
  use GenServer

  @ip {127, 0, 0, 1}
  @port 2356

  def send_message(pid, message) do
    GenServer.cast(pid, {:message, message})
  end

  def start do
    GenServer.start(__MODULE__, %{socket: nil})
  end

  def init(state) do
    send(self(), :connect)
    {:ok, state}
  end

  def handle_info(:connect, state) do
    case :gen_tcp.connect('broker', @port, [:binary, active: true]) do      
      {:ok, socket} ->
        {:noreply, %{state | socket: socket}}
      {:error, reason} ->
        disconnect(state, reason)
    end
  end

  def handle_info({:tcp, _, data}, state) do
    {:noreply, state}
  end

  def handle_info({:tcp_closed, _}, state), do: {:stop, :normal, state}
  def handle_info({:tcp_error, _}, state), do: {:stop, :normal, state}

  def handle_cast({:message, message}, %{socket: socket} = state) do
    :ok = :gen_tcp.send(socket, message)
    {:noreply, state}
  end

  def disconnect(state, reason) do
    {:stop, :normal, state}
  end
end