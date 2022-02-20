defmodule TweetsTest do
  use ExUnit.Case
  doctest Tweets

  test "greets the world" do
    assert Tweets.hello() == :world
  end
end
