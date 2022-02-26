defmodule Worker do
  @moduledoc false
  use GenServer

  #  client side functions
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name:__MODULE__)
  end

  #  server side functions / callbacks
  def init(_state) do
    {:ok, []}
  end

end
