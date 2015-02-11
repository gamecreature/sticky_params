# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sticky_params/version'

Gem::Specification.new do |spec|
  spec.name          = "sticky_params"
  spec.version       = StickyParams::VERSION

  spec.authors       = ["Rick Blommers"]
  spec.email         = ["rick@blommersit.nl"]
  spec.summary       = "A rails gem that automaticly remembers request parameters between requests"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/gamecreature/sticky_params"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
