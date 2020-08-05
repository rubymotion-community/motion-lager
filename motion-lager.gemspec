# -*- encoding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name          = "motion-lager"
  spec.version       = "1.0.0"
  spec.authors       = ["Andrew Havens"]
  spec.email         = ["email@andrewhavens.com"]
  spec.description   = %q{Full featured logger for use in RubyMotion apps.}
  spec.summary       = %q{Full featured logger for use in RubyMotion apps.}
  spec.homepage      = "https://github.com/rubymotion-community/motion-lager"
  spec.license       = "MIT"

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
end
