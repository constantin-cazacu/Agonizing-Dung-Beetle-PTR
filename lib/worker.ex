defmodule Worker do
  @moduledoc false
  use GenServer
  require Logger

  #  client side functions
  def start_link(index) do
    Logger.info("Starting Worker")
    GenServer.start_link(__MODULE__, %{}, name: String.to_atom("Worker#{index}"))
  end

  #  server side functions / callbacks
  def init(state) do
    {:ok, state}
  end

  def receive_tweet(pid, tweet) do
    GenServer.cast(pid, {:forward_tweet, tweet})
  end

  def handle_cast({:forward_tweet, tweet}, state) do

    if tweet == "{\"message\": panic}" do
      Process.exit(self(), :kill)
    end

    IO.puts("worker with #{inspect(self())} says #{tweet}")

#    {:ok, json} = Poison.decode(tweet)
#    "Worker#{inspect(self())}}" <> " " <> json["message"]["tweet"]["text"] <> "\r\n"
#    message = parse_tweet(tweet)
#    TODO: put sleep time

#    if message == :kill_worker do
#      worker_pid = self()
#      PoolSupervisor.stop_worker(worker_pid)
#    end
    {:noreply, state}
  end

#  defp parse_tweet(tweet) do
#    if tweet == "{\"message\": panic}" do
#      :kill_worker
#    else
#      {:ok, json} = Poison.decode(tweet)
#      "Worker#{inspect(self())}}" <> " " <> json["message"]["tweet"]["text"] <> "\r\n"
#    end
#  end

end
