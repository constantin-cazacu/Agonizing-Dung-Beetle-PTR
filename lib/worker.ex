defmodule Worker do
  @moduledoc false
  use GenServer

  #  client side functions
  def start_link(index) do
    GenServer.start_link(__MODULE__, %{index: index}, [name: :"Worker#{index}"])
  end

  #  server side functions / callbacks
  def init(_state) do
    {:ok, []}
  end

end
