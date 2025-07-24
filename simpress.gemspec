Gem::Specification.new do |spec|
  spec.name = "simpress"
  spec.version = "0.0.1"
  spec.homepage = "https://github.com/kinjouj"
  spec.summary = "simpress"
  spec.authors = "kinojouj"
  spec.license = "MIT"
  spec.required_ruby_version = ">=3.0.0"
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.files = Dir["lib/**/*"]
  spec.require_paths = [
    "lib",
    "vendor/libs/ruby-jsonable/lib"
  ]
  spec.add_dependency "classy_hash"
  spec.add_dependency "erubis", "2.7.0"
  spec.add_dependency "redcarpet", "3.6.1"
  spec.add_dependency "stringex"
  spec.add_dependency "tee"
end
