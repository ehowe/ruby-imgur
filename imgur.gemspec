# -*- encoding: utf-8 -*-
require File.expand_path('../lib/imgur/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Eugene Howe"]
  gem.email         = ["eugene@xtreme-computers.net"]
  gem.description   = ""
  gem.summary       = ""
  gem.homepage      = "http://github.com/ehowe/imgur.git"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "imgur"
  gem.require_paths = ["lib"]
  gem.version       = Imgur::VERSION

  gem.add_dependency "multi_json"
  gem.add_dependency "rack-client"
  gem.add_dependency "cistern", "~> 0.1.3"
  gem.add_dependency "addressable"
  gem.add_dependency "oauth"
end
