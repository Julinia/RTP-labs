defmodule TCPServer.Application do
    use Application
  
    @impl true
    def start(_type, _args) do
        port = String.to_integer(System.get_env("PORT") || "4040")
    
        children = [
          {Task.Supervisor, name: TCPServer.TaskSupervisor},
          {Task, fn -> TCPServer.accept(port) end}
        ]
    
        opts = [strategy: :one_for_one, name: TCPServer.Supervisor]
        Supervisor.start_link(children, opts)
      end
  end