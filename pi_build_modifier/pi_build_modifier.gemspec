# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pi_build_modifier/version'

Gem::Specification.new do |spec|
  spec.name = 'pi_build_modifier'
  spec.version = PiBuildModifier::VERSION
  spec.authors = ['Beate Ottenwälder']
  spec.summary = %q{Write a short summary, because Rubygems requires one.}
  spec.description = %q{ Write a longer description or delete this line.}
#  #spec.homepage      = "Put your gem's website or public repo URL here."
  spec.license = 'MIT'

# Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
# to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = Dir.glob('{bin,lib}/**/*') + %w(LICENSE.txt README.md)
  #`git ls-files -z`.split("\x0").reject do |f|
  #   f.match(%r{^(test|spec|features)/})
  # end

  spec.executables   << 'pi_build_modifier'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_runtime_dependency 'thor', '~> 0'
end
