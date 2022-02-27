defmodule PoolSupervisor do
  @moduledoc false
  use DynamicSupervisor

  def start_link() do
    pool_supervisor = DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    Supervisor.start_child(4)
  end

  def get_worker_number() do
    DynamicSupervisor.count_children(__MODULE__).active
  end

  def start_worker(0) do

  end

  def start_worker(n) do
    index = DynamicSupervisor.count_children(__MODULE__).active
    DynamicSupervisor.start_child(__MODULE__, {Worker, index})
    start_worker(n-1)
  end

  def stop_worker(0) do

  end

  def stop_worker(n) do
    IO.puts("Terminating worker")
    index = get_worker_number() - 1
    worker_pid = get_worker_pid() # TO DO: create this private method
    DynamicSupervisor.terminate_child(__MODULE__, worker_pid)
    stop_worker(n-1)
  end

  defp get_worker_pid(name) do

  end

  def init(:ok) do
    DynamicSupervisor.init(startegy: :one_for_one)
  end

end
