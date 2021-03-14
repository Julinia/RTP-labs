defmodule AppSupervisor do
  use DynamicSupervisor

  def start(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def init_worker(path) do
    spec = {Worker, {path}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def stop_worker(worker_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, worker_pid)
  end
end