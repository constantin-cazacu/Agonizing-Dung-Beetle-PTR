defmodule LoadBalancer do
  @moduledoc false
  use GenServer
  require Logger

  #  client side functions
  def start_link() do
    Logger.info("Starting Load Balancer")
    GenServer.start_link(__MODULE__, %{index: 0, workers: []}, name: __MODULE__)
  end

  def receive_tweet(tweet) do
    GenServer.cast(__MODULE__, {:receive_tweet, tweet})
  end

  #  server side functions / callbacks
  def init(state) do
    {:ok, state}
  end

  def handle_cast({:receive_tweet, tweet}, state) do
#    sending tweet to worker in a Round Robin fashion
    %{workers: workers, index: index} = state
    Worker.receive_tweet(:Worker1, tweet)

#    if length(workers) > 0 do
#      Enum.at(workers, rem(index, length(workers)))
#      |> Worker.receive_tweet(pid, tweet)
#    end

#    IO.inspect(tweet)
    {:noreply, %{state | index: index + 1}}
  end

end
