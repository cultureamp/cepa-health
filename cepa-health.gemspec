# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cepa-health/version'

Gem::Specification.new do |gem|
  gem.name          = "cepa-health"
  gem.version       = CepaHealth::VERSION
  gem.authors       = ["Jon Williams"]
  gem.email         = ["jon@jonathannen.com"]
  gem.description   = %q{Health Check Middleware for Rails and Rack-based Applications}
  gem.summary       = %q{Provides the facility for probes that are evaluated when a health URL is accessed.}
  gem.license       = "MIT"
  gem.homepage      = "https://github.com/jonathannen/cepa-health"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rack', '>= 1.2.0'
  gem.add_dependency 'rails', '>= 5.0', "< 7.0"

  gem.add_development_dependency 'rspec-rails', '~> 3.0'
end
