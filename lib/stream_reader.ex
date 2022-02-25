defmodule StreamReader do
  @moduledoc false

  def start_link(url) do
    IO.inspect("starting server conn")
    IO.puts(url)
    #    spawns get_tweet function from the given module, links it to current process
    handle = spawn_link(__MODULE__, :get_tweet, [])
    {:ok, pid} = EventsourceEx.new(url, stream_to: handle)

    #    spawns check_connection function from the given module, links it to current process
    spawn_link(__MODULE__, :check_connection, [url, handle, pid])
    {:ok, self()}
  end

  def get_tweet() do
    receive do
      AutoScaler.receive_data()
    end
    get_tweet()
  end

  def check_connection(url, handle, pid) do
#    starts monitoring the PID
    Process.monitor(pid)
    receive do
      _err ->
        IO.puts("restarting")
        {:ok, new_pid} = EventsourceEx.new(url, stream_to: handle)
        spawn_link(__MODULE__, :check_connection, [url, handle, new_pid])
    end
  end
end
