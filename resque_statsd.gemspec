# -*- encoding: utf-8 -*-
require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "resque_statsd"
  s.version     = ResqueStatsd::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["V Sreekanth"]
  s.email       = ["sreeix@gmail.com"]
  s.homepage    = "https://github.com/sreeix/resque_statsd"
  s.description = s.summary  = %q{Resque plugin that pushes the job statistics to statsd}

  s.rubyforge_project = "resque_statsd"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<statsd>)
  s.add_runtime_dependency(%q<resque>)

  s.add_development_dependency('rspec')
  s.add_development_dependency('rake')
  s.add_development_dependency('bundler')
end
