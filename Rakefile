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
Rspec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end
