defmodule Application do
    use Application
  
    @impl true
    def start(_type, _args) do
        port = String.to_integer(System.get_env("PORT") || "4040")
    
      children = [
        Supervisor.child_spec({Task, fn -> Registry.start end}, id: Registry),
        {Task.Supervisor, name: TCPServer.TaskSupervisor},
        Supervisor.child_spec({Task, fn -> TCPServer.accept(2356) end}, id: Server)
      ]
    
        opts = [strategy: :one_for_one, name: TCPServer.Supervisor]
        Supervisor.start_link(children, opts)
      end
  end