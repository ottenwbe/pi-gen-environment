Gem::Specification.new do |s|
  s.name = 'pi-gen-environment'
  s.version = '0.1.0'
  s.licenses = ['MIT']
  s.summary = 'The pi-gen-environment gem!'
  s.description = 'The pi-gen-environment gem!'
  s.authors = ['Beate Ottenwälder']
  s.executables << 'pi-gen-environment'
  s.files = Dir.glob('{bin,lib,envs}/**/*') + %w(LICENSE README.md)
end