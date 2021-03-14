defmodule Lab1.Application do

  use Application

  @impl true
  def start(_type, _args) do
    url1 = "localhost:4000/tweets/1"
    url2 = "localhost:4000/tweets/2"
  
    children = [
      %{
        id: Manager,
        start: {Manager, :start, []}
      },
      %{
        id: Connection1,
        start: {Connection, :start_connection, [url1]}
      },
      %{
        id: Connection2,
        start: {Connection, :start_connection, [url2]}
      }
    ]

    opts = [strategy: :one_for_one, name: Lab1.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
