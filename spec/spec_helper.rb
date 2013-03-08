# encoding: utf-8
unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
  end
end

require "rubygems"
require "rspec"
require "fakeweb"
require "oauth"

$:.unshift "lib"
require 'quickeebooks'

def mock_error(subject, message)
  mock_exit do
    mock(subject).puts("ERROR: #{message}")
    yield
  end
end

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

def mock_exit(&block)
  block.should raise_error(SystemExit)
end

RSpec.configure do |config|
  config.color_enabled = true
end

def fixture_path
  File.expand_path("../xml", __FILE__)
end

def onlineFixture(file)
  File.new(fixture_path + '/online/' + file).read
end

def sharedFixture(file)
  File.new(fixture_path + '/shared/' + file).read
end

def windowsFixture(file)
  File.new(fixture_path + '/windows/' + file).read
end

