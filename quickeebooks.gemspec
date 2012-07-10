$:.unshift File.expand_path("../lib", __FILE__)
require "quickeebooks/version"

Gem::Specification.new do |gem|
  gem.name     = "quickeebooks"
  gem.version  = Quickeebooks::VERSION

  gem.author   = "Cody Caughlan"
  gem.email    = "toolbag@gmail.com"
  gem.homepage = "http://github.com/ruckus/quickeebooks"
  gem.summary  = "REST integration with Quickbooks Online"

  gem.description = gem.summary

  gem.files = Dir["**/*"]#.select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test/)} }

  gem.add_dependency 'roxml'
  gem.add_dependency 'oauth'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'activemodel'
  gem.add_dependency 'uuidtools'
  
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rcov',   '~> 0.9.8'
  gem.add_development_dependency 'rr',     '~> 1.0.2'
  gem.add_development_dependency 'rspec',  '~> 2.0.0'
  gem.add_development_dependency 'fakeweb'
end
