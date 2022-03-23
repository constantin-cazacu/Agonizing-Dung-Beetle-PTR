defmodule LoadBalancer do
  @moduledoc false
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

  def handle_cast({:receive_tweet, tweet}, index) do
#    sending tweet to worker in a Round Robin fashion
    workers = PoolSupervisor.get_worker_list()
    if length(workers) > 0 do
      {_, worker_pid, _, _} = Enum.at(workers, rem(index, length(workers)))
      Worker.receive_tweet(worker_pid, tweet)
    end

    {:noreply, index + 1}
  end

end
