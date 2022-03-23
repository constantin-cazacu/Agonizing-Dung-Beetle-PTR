c "lib/worker.ex"
c "lib/load_balancer.ex"
c "lib/pool_supervisor.ex"
c "lib/auto_scaler.ex"
c "lib/AgonizingDungBeetlePTR.ex"

Worker.start_link(1)
LoadBalancer.start_link()
LoadBalancer.receive_tweet("hiiii")
PoolSupervisor.start_link()
AutoScaler.start_link()
AgonizingDungBeetlePTR.start()

mix run --no-halt --eval ":observer.start"