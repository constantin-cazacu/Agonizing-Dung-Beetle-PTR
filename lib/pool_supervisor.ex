defmodule PoolSupervisor do
  @moduledoc false
  use DynamicSupervisor

  def start_link() do
    pool_supervisor = DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_worker_number() do
    DynamicSupervisor.count_children(__MODULE__).active
  end

  def start_child(0) do

  end

  def start_child(n) do
    index = DynamicSupervisor.count_children(__MODULE__).active
    DynamicSupervisor.start_child(__MODULE__, {Worker, index})
    start_child(n-1)
  end

  def stop_child(0) do

  end

  def stop_child(n) do
    IO.puts("Terminating worker")
    index = get_worker_number() - 1
    worker_pid = get_worker_pid() # TO DO: create this private method
  end

  defp get_worker_pid(name) do

  end

  def init(:ok) do
    DynamicSupervisor.init(children, startegy: :one_for_one)
  end

end
