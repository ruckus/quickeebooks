# encoding: utf-8
unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
  end
end

require "rubygems"
require "rspec"

$:.unshift "lib"

def mock_error(subject, message)
  mock_exit do
    mock(subject).puts("ERROR: #{message}")
    yield
  end
end

def mock_exit(&block)
  block.should raise_error(SystemExit)
end

RSpec.configure do |config|
  config.color_enabled = true
  config.mock_with :rr
end
