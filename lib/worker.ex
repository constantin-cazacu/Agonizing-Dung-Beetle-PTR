defmodule Worker do
  @moduledoc false
  use GenServer

  #  client side functions
  def start_link(index) do
    GenServer.start_link(__MODULE__, name: "Worker#{index}}")
  end

  #  server side functions / callbacks
  def init(state) do
    {:ok, state}
  end

  def handle_cast({:forward_tweet, tweet}, state) do
    message = parse_tweet(tweet)
#    TODO: put sleep time

    if message == :kill_worker do
      worker_pid = self()
      PoolSupervisor.stop_worker(worker_pid)
    end
  end

  defp parse_tweet(tweet) do
    if tweet == "{\"message\": panic}" do
      :kill_worker
    else
      {:ok, json} = Poison.decode(tweet)
      "Worker#{inspect(self())}}" <> " " <> json["message"]["tweet"]["text"] <> "\r\n"
    end
  end

end
