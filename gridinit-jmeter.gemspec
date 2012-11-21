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
  gem.add_dependency("rest-client")
  gem.add_dependency("nokogiri")
  gem.add_runtime_dependency('json-jruby') if RUBY_PLATFORM == 'java'

  gem.files         = `git ls-files`.split($/)
  gem.executables   << 'grid'
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
