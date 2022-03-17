defmodule PoolSupervisor do
  @moduledoc false
  use DynamicSupervisor
  require Logger

  def start_link() do
    supervisor = DynamicSupervisor.start_link(__MODULE__, %{}, name: __MODULE__)
    IO.inspect("starting Pool Supervisor")
    supervisor
  end

  def get_worker_number() do
    DynamicSupervisor.count_children(__MODULE__).active
  end

  def start_worker(0) do
    :ok
  end

  def start_worker(n) do
#    TODO: re-make logic here to keep a record of workers
    index = get_worker_number()
    DynamicSupervisor.start_child(__MODULE__, {Worker, index + 1})
    Logger.info("Pool Supervisor added Worker No.#{index + 1}}}")
    start_worker(n-1)
  end

  def get_worker_list() do
    DynamicSupervisor.which_children(__MODULE__)
  end

  def init(_) do
    supervisor = DynamicSupervisor.init(max_children: 1000, strategy: :one_for_one)
    supervisor
  end

end
