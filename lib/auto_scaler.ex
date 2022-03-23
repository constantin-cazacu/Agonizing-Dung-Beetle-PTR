defmodule AutoScaler do
  @moduledoc false
  use GenServer
  require Logger

#  client side functions
  def start_link() do
    Logger.info(IO.ANSI.format([:yellow, "Starting Auto-Scaler"]))
    counter = 0
    GenServer.start_link(__MODULE__, counter, name: __MODULE__)
  end

  def receive_data() do
    GenServer.cast(__MODULE__, :increment)
  end

#  callbacks
  def init(state) do
    counter_reset()
    PoolSupervisor.start_worker(4)
    {:ok, state}
  end

  defp counter_reset() do
#    collecting the number of tweets per second then restarting the counter
    count_pid = self()
    spawn(fn ->
      Process.sleep(1000)
      GenServer.cast(count_pid, :counter_reset)
    end)
  end

  def handle_cast(:increment, counter) do
    {:noreply, counter + 1}
  end

  def handle_cast(:counter_reset, counter) do
    PoolSupervisor.auto_scale(counter)
    counter_reset()
    counter = 0
    {:noreply, counter}
  end
end
