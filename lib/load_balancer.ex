defmodule LoadBalancer do
  @moduledoc false
  use GenServer

  #  client side functions
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name:__MODULE__)
  end

  def receive_tweet(tweet) do
    GenServer.cast(__MODULE__, {:receive_tweet, tweet})
  end

  #  server side functions / callbacks
  def init(_state) do
    {:ok, []}
  end

  def handle_cast({:receive_tweet, tweet}, state) do
#    TO DO: find out how to send to a list of current workers
    index = &PoolSupervisor.get_worker_number()
#    TO DO: use created index to send to a certain worker#[index] a task
#    and decrement current index
#    plus create a case for when n = 0


    {:noreply, []}
  end



end
