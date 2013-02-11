$:.unshift File.expand_path("../lib", __FILE__)
require "quickeebooks/version"

Gem::Specification.new do |gem|
  gem.name     = "quickeebooks"
  gem.version  = Quickeebooks::VERSION

  gem.author   = "Cody Caughlan"
  gem.email    = "toolbag@gmail.com"
  gem.homepage = "http://github.com/ruckus/quickeebooks"
  gem.summary  = "REST API to Quickbooks Online/Windows via Intuit Data Services"

  gem.description = gem.summary

  gem.files = Dir["**/*"]

  gem.add_dependency 'roxml'
  gem.add_dependency 'oauth'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'activemodel'
  gem.add_dependency 'uuidtools'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'rr',     '~> 1.0.2'
  gem.add_development_dependency 'rspec',  '2.11.0'
  gem.add_development_dependency 'fakeweb'
end
