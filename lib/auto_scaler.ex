defmodule AutoScaler do
  @moduledoc false
  use GenServer
  require Logger

#  client side functions
  def start_link() do
#    Logger.info("Starting Auto-Scaler")
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    PoolSupervisor.start_worker(4)
    {:ok, state}
  end

#  TODO: autos scale full implementation
end
