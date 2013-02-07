Resque-Statsd
==============


A resque plugin that pushes worker statistics to statsd.


`gem install resque_statsd`

or

`gem 'resque_statsd'` in the Gemfile


add the following to your resque workers

`extend Resque::Plugins::Statsd`

By default this would send it to the statsd that has been configured.

This will by default do the following

* total_resque_failures
* total_resque_failures:<WorkerName>
* total_enqueues
* total_enqueues:<WorkerName>
* total_dequeues
* total_dequeues:<WorkerName>
* total_successful
* total_successful:<WorkerName>
* duration:<WorkerName>

  Customizations.
===============

By adding something like this

  `@extra_stats_key = {:duration => [:hostname, :queuename]}`

This will also add the duration:<hostname> as a stat
This will also add the duration:<queue> as a stat

Following default tasks are available
* queuename - Name of the queue on which this task was picked up
* hostname  - Name of the machine on which the task was executed
* classname - The default. Name of the worker that was executed.

More Customizations
=======

  `@extra_stats_key = {:failure => Proc.new {|e, args| e.to_s}}`

  This will add a stat key for

total_resque_failures:<Exception>

  Following hooks are available
  * failure
  * duration
  * enqueue
  * dequeue
  * fork
