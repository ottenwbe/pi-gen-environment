require_relative 'lib/pi_customizer/version'

Gem::Specification.new do |s|
  s.name = 'pi_customizer_environment'
  s.version = PiCustomizer::Version
  s.licenses = ['MIT']
  s.summary = 'The pi_customizer_environment gem!'
  s.description = 'The pi_customizer_environment gem!'
  s.authors = ['Beate Ottenwälder']
  s.executables << 'pi_customizer'
  s.files = Dir.glob('{bin,lib,envs}/**/*') + %w(LICENSE README.md)
end