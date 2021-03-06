
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ray/version"

Gem::Specification.new do |spec|
  spec.name          = "ray"
  spec.version       = Ray::VERSION
  spec.authors       = ["Aybars Hazar Şimşir"]
  spec.email         = ["aybarshazar@gmail.com"]

  spec.summary       = %q{A Rack-based Web Framework}
  spec.description   = %q{A Rack-based Web Framework with extra awesome features.}
  spec.homepage      = "https://github.com/aybarshazar/rulers"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"

  spec.add_development_dependency "rack-test", "~> 1.1"
  spec.add_development_dependency "minitest", "~> 5.14"

  spec.add_runtime_dependency "rack", "~> 2.2"
  spec.add_runtime_dependency "erubis", "~> 2.7"
  spec.add_runtime_dependency "multi_json", "~> 1.14"
  spec.add_runtime_dependency "sqlite3", "~> 1.4"
end
