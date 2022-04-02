defmodule HashtagsStats do
  @moduledoc"""
  Hashtag Stats - actor who parses the hashtag and outputs
  the top 5 hashtags once every 5 seconds
  """
  use GenServer
  require Logger

#  client-side functions
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def parse_tags(tweet) do
    GenServer.cast(__MODULE__, {:hashtag, tweet})
  end

#  server callbacks
  def init(state) do
    Process.send_after(self(), :get_stats, 5000)
    {:ok, state}
  end

  @doc """
  parse hashtags and store them in a map composed of tuples
  {tag, occurrence} and updates if a present hashtag is occurring
  repeatedly, all this is stored in state
  """
  def handle_cast({:hashtag, tweet}, state) do
    {:ok, tweet_data} = Poison.decode(tweet)
    hashtags = tweet_data["message"]["tweet"]["entities"]["hashtags"]
    if length(hashtags) > 0 do
      hashtags_content = Enum.map(hashtags, fn x -> x["text"] end)
      hashtags_stats = Enum.reduce(
        hashtags_content,
        state,
        fn tag, acc ->
          if Map.has_key?(state, tag) do
            Map.put(acc, tag, Map.get(state, tag) + 1)
          else
            Map.put(acc, tag, 1)
          end
        end
      )
      {:noreply, hashtags_stats}
    else
      {:noreply, state}
    end
  end

  @doc """
  transform the map into a list, sort it in ascending order
  """
  def handle_info(:get_stats, state) do
    sorted =
      state
      |> Map.to_list()
      |> Enum.sort(fn {_key1, value1}, {_key2, value2} -> value1 <= value2 end)

    top_tag = find_top_hashtag(sorted)
    Process.send_after(self(), :get_stats, 5000)
    {:noreply, state}
  end

  @doc """
  private function which takes the bottom 5 (most used hashtags)
  and prints them every 5 seconds
  """
  defp find_top_hashtag(tags_stats) do
    top_tags = Enum.take(tags_stats, -5)
    popular_tags = Enum.reverse(top_tags)
    Enum.each(popular_tags, fn {tag, occurrence} ->
      Logger.info(IO.ANSI.format([:green, "Hashtag: #{tag} - Occurrence: #{occurrence}"]))end)
  end

end