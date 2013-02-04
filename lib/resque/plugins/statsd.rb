module Resque
  module Plugins
    module Statsd
      DEFAULT_TASKS = {
        :hostname => Proc.new{ @stat_hostname ||= `hostname`.strip},
        :classname => Proc.new {self.class},
        :queuename => Proc.new {|args| @queue}
      }
      def statsd
        $statsd || @statsd_server
      end

      def statsd=(statsd)
        @statsd_server = statsd
      end

      # Stuff to hook up to.
      # Probably need to use batch.
      def around_perform_stats(*args)
        start = Time.now
        yield
        time_taken = Time.now - start
        statsd.timing("duration:#{self}", time_taken)
        statsd.increment("total_successful:#{self}")
        statsd.increment("total_successful")
        if extra_stats_key
          Array(extra_stats_key[:around_perform]).each { |item| statsd.timing("duration:#{DEFAULT_TASKS[item].call(args)}", time_taken)}
        end
      end

      def on_failure_stats(*args)
        statsd.increment("total_resque_failures")
        statsd.increment("total_resque_failures:#{self}")
      end

      def after_enqueue_stats(*args)
        statsd.increment("total_enqueues")
        statsd.increment("total_enqueues:#{self}")
      end

      def after_dequeue_stats(*args)
        statsd.increment("total_dequeues")
        statsd.increment("total_dequeues:#{self.class}")
      end
      
      def extra_stats_key
        @extra_stats_key ||= {}
      end
    end
  end
end
