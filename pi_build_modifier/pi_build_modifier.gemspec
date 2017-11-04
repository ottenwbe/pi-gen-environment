# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'pi_build_modifier/version'

Gem::Specification.new do |spec|
  spec.name = 'pi_build_modifier'
  spec.version = PiBuildModifier::VERSION
  spec.license = 'MIT'
  spec.authors = ['Beate Ottenwälder']
  spec.summary = %q{Write a short summary, because Rubygems requires one.}
  spec.description = %q{ Write a longer description or delete this line.}

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0'
  spec.add_development_dependency 'rdoc', '~> 5.1'
  spec.add_runtime_dependency 'thor', '~> 0.20'
  spec.add_runtime_dependency 'json', '~> 2.1'
end
