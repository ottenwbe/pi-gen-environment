require 'simplecov'
require 'rspec'
#require 'codecov'

SimpleCov.start do
  add_filter %r{/spec/}
end
#  SimpleCov.formatter = SimpleCov::Formatter::Codecov

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
