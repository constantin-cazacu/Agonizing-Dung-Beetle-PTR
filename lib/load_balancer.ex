defmodule LoadBalancer do
  @moduledoc false
  use GenServer

  #  client side functions
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name:__MODULE__)
  end

  def receive_tweet(tweet) do
    GenServer.cast(__MODULE__, {:rcv_tweet, tweet})
  end

  #  server side functions / callbacks
  def init(_state) do
    {:ok, []}
  end

  def handle_cast({:rcv_tweet, tweet}, _state) do
    {:noreply, []}
#    TO DO: find out how to send to a list of current workers
  end



end
