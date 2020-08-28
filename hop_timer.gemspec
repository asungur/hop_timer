lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hop_timer/version'

Gem::Specification.new do |spec|
  spec.name          = "hop_timer"
  spec.version       = HopTimer::VERSION
  spec.authors       = ["Alican Sungur"]
  spec.email         = ["sunguralican@gmail.com"]

  spec.summary       = "A tool that measures runtime between checkpoints"
  spec.description   = "A ruby gem that calculates runtime between user defined checkpoints."
  spec.homepage      = "https://github.com/asungur/hop_timer"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency 'coveralls'
end
