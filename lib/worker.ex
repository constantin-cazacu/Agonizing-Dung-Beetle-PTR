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
    #    TODO: put sleep time
    GenServer.cast(pid, {:forward_tweet, tweet})
  end

  def handle_cast({:forward_tweet, tweet}, state) do

    if tweet == "{\"message\": panic}" do
      Process.exit(self(), :kill)
    end

#    IO.puts("Worker #{inspect(self())} says #{inspect(tweet)}")

    {:ok, tweet_data} = Poison.decode(tweet)
    tweet_msg = tweet_data["message"]["tweet"]["text"]
    IO.puts("Worker #{inspect(self())} says #{inspect(tweet_msg)}")
#    TODO: standard form for logs
#    TODO: max char length

    {:noreply, state}
  end



end
