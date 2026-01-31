# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "simpress"
  spec.version = "0.0.1"
  spec.homepage = "https://github.com/kinjouj"
  spec.summary = "simpress"
  spec.authors = "kinojouj"
  spec.license = "MIT"
  spec.required_ruby_version = ">=3.3.9"
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.files = Dir["lib/**/*"]
  spec.require_paths = ["lib"]
  spec.add_dependency "erubi"
  spec.add_dependency "natto"
  spec.add_dependency "ox"
  spec.add_dependency "redcarpet"
  spec.add_dependency "stackprof"
  spec.add_dependency "stringex"
  spec.add_dependency "tee"
  spec.add_dependency "tilt"
  spec.add_dependency "xxhash"
end
