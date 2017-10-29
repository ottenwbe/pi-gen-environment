require 'simplecov'
require 'codecov'

module PiCustomizer
  SimpleCov.start
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
