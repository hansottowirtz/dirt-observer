require 'bundler/gem_tasks'
require 'rake/testtask'

task :default => :test
task :test do
  Dir.glob("./test/test.rb")
end

task :console do
  sh "irb -rubygems -I lib -r minecraft_bridge.rb"
end
