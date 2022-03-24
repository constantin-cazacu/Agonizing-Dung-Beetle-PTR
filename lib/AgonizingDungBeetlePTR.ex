defmodule AgonizingDungBeetlePTR do
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info(IO.ANSI.format([:yellow, "starting Application"]))
    url1 = "http://localhost:4000/tweets/1"
    url2 = "http://localhost:4000/tweets/2"

    children = [
      %{
        id: LoadBalancer,
        start: {LoadBalancer, :start_link, []}
      },
      %{
        id: PoolSupervisor,
        start: {PoolSupervisor, :start_link, []}
      },
      %{
        id: AutoScaler,
        start: {AutoScaler, :start_link, []}
      },
      %{
      id: StreamReader1,
      start: {StreamReader, :start_link, [url1]}
      },
      %{
        id: StreamReader2,
        start: {StreamReader, :start_link, [url2]}
      },
#      %{
#        id: LoadBalancer,
#        start: {LoadBalancer, :start_link, []}
#      },
#      %{
#        id: PoolSupervisor,
#        start: {PoolSupervisor, :start_link, []}
#      },
#      %{
#        id: AutoScaler,
#        start: {AutoScaler, :start_link, []}
#      },
#      %{
#        id: Worker,
#        start: {Worker, :start_link, [1]}
#      },
    ]

    opts = [strategy: :one_for_one, max_restarts: 100, name: __MODULE__]

    Supervisor.start_link(children, opts)
  end

end

