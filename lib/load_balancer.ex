defmodule LoadBalancer do
  @moduledoc"""
  Load Balancer - distributes the tweet dta to the worker pool
  in a basic Round Robin fashion based on a index stored in the
  module's state in order to keep in mind to which worker it has
  to send the next tweet
  """
  use GenServer
  require Logger

  #  client side functions
  def start_link() do
    Logger.info(IO.ANSI.format([:yellow,"Starting Load Balancer"]))
#    index = 0
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def receive_tweet(tweet) do
    GenServer.cast(__MODULE__, {:receive_tweet, tweet})
  end

  #  server side functions / callbacks
  def init(state) do
    {:ok, state}
  end

  @doc"""
  sending tweet forwarded from the Stream Reader to
  worker in a Round Robin fashion
  tweet 1 -> worker 1
  tweet 2 -> worker 2
  tweet 3 -> worker 3
  ...
  tweet 8 -> worker 1
  tweet 9 -> worker 2
  ...
  """
  def handle_cast({:receive_tweet, tweet}, index) do
    workers = PoolSupervisor.get_worker_list()
    if length(workers) > 0 do
      {_, worker_pid, _, _} = Enum.at(workers, rem(index, length(workers)))
      Worker.receive_tweet(worker_pid, tweet)
    end

    {:noreply, index + 1}
  end

end
