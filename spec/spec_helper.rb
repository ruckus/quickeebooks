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

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.color_enabled = true
end
