# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foreman-export-daemontools/version'

Gem::Specification.new do |gem|
  gem.name          = "foreman-export-daemontools"
  gem.version       = Foreman::Export::Daemontools::VERSION
  gem.authors       = ["Ryosuke IWANAGA"]
  gem.email         = ["riywo.jp@gmail.com"]
  gem.description   = %q{foreman exporting daemontools run script}
  gem.summary       = %q{foreman exporting daemontools run script}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
