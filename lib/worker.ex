defmodule Worker do
  @moduledoc"""
  Worker - actor whose job is to parse the tweet data,
  if a panic message is received then the worker should
  crash and be restarted by its Pool Supervisor
  """
  use GenServer
  require Logger

  #  client side functions
  def start_link(index) do
    Logger.info(IO.ANSI.format([:yellow,"Starting Worker"]))
    GenServer.start_link(__MODULE__, %{}, name: String.to_atom("Worker#{index}"))
  end

  def receive_tweet(pid, tweet) do
    GenServer.cast(pid, {:forward_tweet, tweet})
  end

  #  server side functions / callbacks
  def init(state) do
    {:ok, state}
  end

  @doc """
  in case of "{\"message\": panic}" the worker will crash
  if everything is good then we send the data to the
  Hashtag Stats actor and print the tweet a to the console
  """
  def receive_tweet(pid, tweet) do
    GenServer.cast(pid, {:forward_tweet, tweet})
  end

  def handle_cast({:forward_tweet, tweet}, state) do
    if tweet == "{\"message\": panic}" do
      Process.exit(self(), :kill)
    end
    HashtagsStats.parse_tags(tweet)
    {:ok, tweet_data} = Poison.decode(tweet)
    tweet_msg = tweet_data["message"]["tweet"]["text"]
    Process.sleep(Enum.random(50..500))

    IO.puts("Worker #{inspect(self())} says #{inspect(String.slice(tweet_msg, 0..50))}...")

    {:noreply, state}
  end

end
