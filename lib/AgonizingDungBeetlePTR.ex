defmodule AgonizingDungBeetlePTR do
  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("starting Application")
    url = "http://localhost:4000/tweets/1"

    children = [
      %{
      id: StreamReader,
      start: {StreamReader, :start_link, [url]}
      },
      %{
        id: LoadBalancer,
        start: {LoadBalancer, :start_link, []}
      },
      %{
        id: PoolSupervisor,
        start: {PoolSupervisor, :start_link, []}
      },
    ]

    opts = [strategy: :one_for_one, max_restarts: 100, name: __MODULE__]

    Supervisor.start_link(children, opts)
  end

end

