# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aldous/version'

Gem::Specification.new do |spec|
  spec.name          = "aldous"
  spec.version       = Aldous::VERSION
  spec.authors       = ["Alan Skorkin"]
  spec.email         = ["alan@skorks.com"]
  spec.description   = %q{Rails brave new world}
  spec.summary       = %q{Rails brave new world}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
end
