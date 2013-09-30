require "rubygems"
require "bundler"
Bundler.setup

require "rake"
require "rspec"
require "rspec/core/rake_task"

$:.unshift File.expand_path("../lib", __FILE__)
require "quickeebooks"

task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

desc "Open an irb (or pry) session preloaded with Quickeebooks"
task :console do
  begin
    require 'pry'
    sh %{pry -I lib -r quickeebooks.rb}
  rescue LoadError => _
    sh 'irb -rubygems -I lib -r quickeebooks.rb'
  end
end
