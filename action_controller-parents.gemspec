# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'action_controller/parents/version'

Gem::Specification.new do |spec|
  spec.name          = "action_controller-parents"
  spec.version       = ActionController::Parents::VERSION
  spec.authors       = ["Maarten Claes"]
  spec.email         = ["maartencls@gmail.com"]
  spec.description   = %q{Easily access parent resources}
  spec.summary       = %q{Easily access parent resources}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "mutant", "~> 0.3.5"
  spec.add_development_dependency "appraisal", "1.0.0.beta2"

  spec.add_dependency "activesupport", ">= 3.0.0"
end
