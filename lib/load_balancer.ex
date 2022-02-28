defmodule LoadBalancer do
  @moduledoc false
  use GenServer

  #  client side functions
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
    IO.inspect("starting Load Balancer")

  end

  def receive_tweet(tweet) do
    GenServer.cast(__MODULE__, {:receive_tweet, tweet})
  end

  #  server side functions / callbacks
  def init(_state) do
    {:ok, []}
  end

  def handle_cast({:receive_tweet, tweet}, state) do
#    TO DO: use created index to send to a certain worker#[index] a task
#    and decrement current index
#    plus create a case for when n = 0

    tweet
    |> Jason.decode()
    |> Map.get("Message")
    |> IO.inspect()

#    IO.inspect(tweet)

#    index = &PoolSupervisor.get_worker_number()
#    send_to_worker(index, tweet)

    {:noreply, []}
  end

# CURRENT ISSUE: gotta find a way to send to worker and update to the next tweet to be sent
  defp send_to_worker(index, tweet) do
    send(get_worker_name(index), tweet)
    send_to_worker(index-1, tweet)
  end

  defp send_to_worker(0, tweet) do

  end

  defp get_worker_name(index) do
    String.to_atom("Worker" <> Integer.to_string(index))
  end


end
