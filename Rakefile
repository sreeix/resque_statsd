require 'bundler'

Bundler::GemHelper.install_tasks

$LOAD_PATH.unshift 'lib'

task :default => :test

# Tests
desc "Run tests"
task :test do
  Dir['test/*_spec.rb'].each do |f|
    require File.expand_path(f)
  end
end
