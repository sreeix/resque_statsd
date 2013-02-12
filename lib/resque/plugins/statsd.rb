require File.expand_path('../../hook', __FILE__)
module Resque
  module Plugins
    module Statsd
      DEFAULT_TASKS = {
        :hostname => Proc.new{ @stat_hostname ||= `hostname`.strip},
        :classname => Proc.new {self},
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
        run_hooks(:duration, :duration, args) {|key| statsd.timing(key, time_taken)}
      end

      def on_failure_stats(*args)
        statsd.increment("total_resque_failures")
        statsd.increment("total_resque_failures:#{self}")
        run_hooks(:failure, :total_resque_failures, args){|key| statsd.increment(key)}
      end

      def after_enqueue_stats(*args)
        statsd.increment("total_resque_enqueues")
        statsd.increment("total_resque_enqueues:#{self}")
        run_hooks(:enqueue, :total_enqueues, args){|key| statsd.increment(key)}
      end

      def after_dequeue_stats(*args)
        statsd.increment("total__resque_dequeues")
        statsd.increment("total__resque_dequeues:#{self}")
        run_hooks(:dequeue, :total_dequeues, args) {|key| statsd.increment(key)}
      end

      def extra_stats_key
        @extra_stats_key ||= {}
      end

      def run_hooks(type, key, args = nil)
        Array(extra_stats_key[type]).each do |item|
          begin
            res = "#{key}:#{Resque::Plugins::Statsd::DEFAULT_TASKS[item].call(args)}"
            puts "**********************************************"
            puts res
            puts "**********************************************"
          rescue
            puts "#{$!}" # Don't throw up if bad stuff happened, like the proc not being there.
          end
          yield(res)  if res
        end
      end
    end
  end
end
