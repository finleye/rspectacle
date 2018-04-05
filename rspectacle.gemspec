# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspectacle/version'

Gem::Specification.new do |spec|
  spec.name          = "rspectacle"
  spec.version       = Rspectacle::VERSION
  spec.authors       = ["Corey Finley"]
  spec.email         = ["finley.corey@gmail.com"]
  spec.summary       = %q{Run specs for altered files}
  spec.description   = %q{Runs associated spec files for modified files in git status}
  spec.homepage      = "http://finleye.github.io"
  spec.license       = "MIT"

  spec.required_ruby_version = '~> 2.0'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables    = ["rspectacle"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 2.99'
  spec.add_development_dependency 'pry', '~> 0.9.12.2'

  spec.add_runtime_dependency 'hashie'
  spec.add_runtime_dependency 'haml', '~> 5.0.4'
end
