defmodule PoolSupervisor do
  @moduledoc"""
  Pool Supervisor - a supervising actor whose job is to keep
  its pool of workers in check, wither increase or decrease it,
  based on information received from Auto Scaler actor, and restart
  crashed workers due to panic messages or other errors
  """
  use DynamicSupervisor
  require Logger

#  client-side functions
  def start_link() do
    supervisor = DynamicSupervisor.start_link(__MODULE__, %{}, name: __MODULE__)
    Logger.info(IO.ANSI.format([:yellow, "starting Pool Supervisor"]))
    supervisor
  end

  def get_worker_number() do
    DynamicSupervisor.count_children(__MODULE__).active
  end

  @doc """
  the scenario where the required number of workers to be added/removed is zero
  """
  def start_worker(0) do
    :ok
  end

  @doc """
  based on the argument passed to this function the following are taking place:

  if n > 0 Pool Supervisor will add workers while decreasing the count until
  it reaches zero

  if n < 0 Pool Supervisor wil remove workers while increasing the count until
  it reaches zero
  """
  def start_worker(n) do
    case n do
      n when n > 0 ->
        index = get_worker_number()
        DynamicSupervisor.start_child(__MODULE__, {Worker, index + 1})
        Logger.info(IO.ANSI.format([:cyan, "Pool Supervisor added Worker No.#{index + 1}, current pool = #{get_worker_number()}"]))
        start_worker(n-1)

      n when n < 0 ->
#      TODO: safe termination of workers and cutting comms with load balancer
        workers_to_remove = Enum.take(get_worker_list(), n)
        {_, worker_pid, _, _} = Enum.at(workers_to_remove, n)
        DynamicSupervisor.terminate_child(__MODULE__, worker_pid)
        Logger.info(IO.ANSI.format([:red,"Pool Supervisor removed a Worker, current pool = #{get_worker_number()}"]))
        start_worker(n+1)

        _ ->
          nil
    end
    :noreply
  end

  @doc """
  function called by Auto Scaler in order to transform the number of tweets received
  in one second to a number of required workers, if current pool capacity is bigger
  than required it will be decreased, and increased vice versa
  """
  def auto_scale(counter) do
    Logger.info(IO.ANSI.format([:magenta, "counter = #{inspect(counter)}"]))
    desired_worker_no = div(counter, 3) + 1 # +1 for good measure
    current_worker_no = get_worker_number()
    difference = desired_worker_no - current_worker_no
    start_worker(difference)
    :noreply
  end

  @doc """
  getting an up-to-date list of the supervised worker
  """
  def get_worker_list() do
    DynamicSupervisor.which_children(__MODULE__)
  end

#  callbacks
  def init(_) do
    supervisor = DynamicSupervisor.init(max_restarts: 100, max_children: 1000, strategy: :one_for_one)
#    PoolSupervisor.start_worker(4)
    supervisor
  end

end
