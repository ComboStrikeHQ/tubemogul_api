# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tubemogul_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'tubemogul_api'
  spec.version       = TubemogulApi::VERSION
  spec.authors       = ['Guilherme Goettems Schneider']
  spec.email         = ['guilherme@ad2games.com']

  spec.summary       = 'Tubemogul API Client.'
  spec.description   = 'Tubemogul API Client.'
  spec.homepage      = 'https://www.combostrike.com'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
