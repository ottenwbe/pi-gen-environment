require_relative 'lib/pi_customizer/version'

Gem::Specification.new do |s|
  s.name = 'pi_build_environment'
  s.version = PiCustomizer::VERSION
  s.licenses = ['MIT']
  s.summary = 'The pi_customizer_environment gem!'
  s.description = 'The pi_customizer_environment gem!'
  s.authors = ['Beate Ottenwälder']
  s.executables << 'pi_build_environment'
  s.require_paths = ['lib']
  s.files = Dir.glob('{bin,lib,envs}/**/*') + %w(LICENSE README.md)
end