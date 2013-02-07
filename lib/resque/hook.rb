Resque.after_fork do |job|
  statsd.increment("total_forks")
  run_hooks(:dequeue, :total_dequeues)
end
