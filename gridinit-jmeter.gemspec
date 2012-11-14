# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gridinit-jmeter/version'

Gem::Specification.new do |gem|
  gem.name          = "gridinit-jmeter"
  gem.version       = Gridinit::Jmeter::VERSION
  gem.authors       = ["Tim Koopmans"]
  gem.email         = ["support@gridinit.com"]
  gem.description   = %q{This is a Ruby based DSL for writing JMeter test plans}
  gem.summary       = %q{This is a Ruby based DSL for writing JMeter test plans}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
