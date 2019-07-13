# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'pi_build_modifier/version'

Gem::Specification.new do |spec|
  spec.name = 'pi_build_modifier'
  spec.version = PiBuildModifier::VERSION
  spec.license = 'MIT'
  spec.author = 'Beate Ottenwälder'
  spec.email = 'ottenwbe.public@gmail.com'
  spec.homepage = 'https://github.com/ottenwbe/pi-gen-environment.git'
  spec.summary = 'Modify builds of Raspbian images.'
  spec.description = 'Modifies the build process of a Raspbian image.'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables = spec.files.grep(%r{^bin/}) {|f| File.basename(f)}
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'simplecov', '~> 0.17'
  spec.add_development_dependency 'rdoc', '~> 6.1'
  spec.add_runtime_dependency 'thor', '~> 0.20'
  spec.add_runtime_dependency 'json', '~> 2.2'
  spec.add_runtime_dependency 'openssl', '~> 2.1'
end
