# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative './lib/dat_swagger/version'

Gem::Specification.new do |spec|
  spec.name          = 'dat_swagger'
  spec.version       = DAT::Version
  spec.authors       = ['Jake Sarate']
  spec.email         = ['jake.sarate@dat.com']

  spec.summary       = %q{Convert a swagger.json document into an executable ruby library}
  spec.description   = %q{Convert a swagger.json document into an executable ruby library}
  spec.homepage      = ''
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://10.36.77.177:9292/'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'sinatra', '~> 2.0'
  spec.add_development_dependency 'rspec', '~> 0.1'
  spec.add_development_dependency 'rspec-core', '~> 3.7.1'
  spec.add_development_dependency 'rspec-expectations', '~> 3.7.0'
  spec.add_development_dependency 'pry'
end
