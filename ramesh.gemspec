# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ramesh/version'

Gem::Specification.new do |spec|
  spec.name          = "ramesh"
  spec.version       = Ramesh::VERSION
  spec.authors       = ["dtan4"]
  spec.email         = ["dtanshi45@gmail.com"]
  spec.description   = %q{Command Line Tool for Tokyo-Amesh}
  spec.summary       = %q{Tokyo-Amesh Downloader}
  spec.homepage      = "https://github.com/dtan4/ramesh"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "webmock"

  spec.add_dependency "mini_magick"
end
