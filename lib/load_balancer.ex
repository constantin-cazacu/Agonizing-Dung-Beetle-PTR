defmodule LoadBalancer do
  @moduledoc false
  use GenServer
  require Logger

  #  client side functions
  def start_link() do
    state = %{index: 0, workers: []}
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
    Logger.info("starting Load Balancer")
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
    %{workers, index} = state
    if length(workers) > 0 do
      Enum.at(workers, rem(index, length(workers)))
      |> Genserver.cast({:forward_tweet, tweet})
    end

#    IO.inspect(tweet)
    {:noreply, %{state | index: index + 1}}
  end

end
