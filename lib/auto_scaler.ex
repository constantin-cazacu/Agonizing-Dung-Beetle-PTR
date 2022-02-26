defmodule AutoScaler do
  @moduledoc false
  use GenServer

#  client side functions
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name:__MODULE__)
  end

  def receive_data() do
    GenServer.cast(__MODULE__, :count)
  end

#  server side functions / callbacks
  def init(_state) do
    schedule_work()
    {:ok, %{counter: 0}}
  end

#  REDO ALL THIS BIT FOR OUR USE
  def handle_info(:work, state) do
    desired_number_workers = 1 + div(state.counter, 15)
#    TO DO: define get_nb_children() method
#    actual_number_workers will get the current number of workers from the TopSupervisor

    diff = abs(desired_number_workers - actual_number_workers)
#    scale(:sentiment, desired_number_workers > actual_nb_workers, diff)

    schedule_work()
    {:noreply, %{counter: 0}}
  end


  def handle_cast(:count, state) do
    {:noreply, %{counter: state.counter + 1}}
  end

  defp schedule_work() do
    interval = 1000
    Process.send_after(self(), :work, interval)
  end

end
