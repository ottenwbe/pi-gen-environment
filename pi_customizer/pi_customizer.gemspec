lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pi_customizer/version'

Gem::Specification.new do |s|
  s.name = 'pi_customizer'
  s.version = PiCustomizer::VERSION
  s.licenses = ['MIT']
  s.summary = 'The pi_customizer gem!'
  s.description = 'The pi_customizergem -- gem!'
  s.authors = ['Beate Ottenwälder']
  s.executables << 'pi_customizer'
  s.require_paths = ['lib']
  s.files = Dir.glob('{bin,lib,envs}/**/*') + %w(LICENSE README.md)

  s.add_development_dependency 'bundler', '~> 1.15'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_runtime_dependency 'thor', '~> 0.20'
  s.add_runtime_dependency 'json', '~> 2.1'
end