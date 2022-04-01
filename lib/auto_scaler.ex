defmodule AutoScaler do
  @moduledoc"""
  Auto Scaler - actor who monitors the rate of tweets per second and sends
  instructions to the Pool Supervisor in order to balance the pool of workers
  """
  use GenServer
  require Logger

#  client side functions
  def start_link() do
    Logger.info(IO.ANSI.format([:yellow, "Starting Auto-Scaler"]))
    counter = 0
    GenServer.start_link(__MODULE__, counter, name: __MODULE__)
  end

  @doc """
  every tweet calls for an increment to the counter
  """
  def receive_data() do
    GenServer.cast(__MODULE__, :increment)
  end

#  callbacks
  def init(state) do
    counter_reset()
    PoolSupervisor.start_worker(4)
    {:ok, state}
  end

  @doc """
  private function collecting the number of tweets per second then
  restarting the counter and doing it repeatedly
  """
  defp counter_reset() do
    count_pid = self()
    spawn(fn ->
      Process.sleep(1000)
      GenServer.cast(count_pid, :counter_reset)
    end)
  end

  def handle_cast(:increment, counter) do
    {:noreply, counter + 1}
  end

  @doc """
  sending the tweet count per second to the Pool Supervisor
  and reset the counter
  """
  def handle_cast(:counter_reset, counter) do
    PoolSupervisor.auto_scale(counter)
    counter_reset()
    counter = 0
    {:noreply, counter}
  end
end
