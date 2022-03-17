c "lib/worker.ex"
c "lib/load_balancer.ex"
c "lib/pool_supervisor.ex"
c "lib/auto_scaler.ex"

Worker.start_link(1)
Worker.receive_tweet(:Worker1, "Hello")
LoadBalancer.start_link()
LoadBalancer.receive_tweet("hiiii")
PoolSupervisor.start_link()
AutoScaler.start_link()
