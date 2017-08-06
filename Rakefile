require 'pi-gen-environment'

begin

  require 'rspec/core/rake_task'

  task :default => :test

  RSpec::Core::RakeTask.new(:test) do
    require 'rspec/core/rake_task'
  end

rescue LoadError
  puts 'RSpec is not installed. This means rake is not able to execute tests!'
end

task :run_vagrant do
  PiGen.start(["build", "VAGRANT"])
end

task :run_echo do
  PiGen.start(["build", "ECHO"])
end

task :run_echo_git do
  PiGen.start(["build", "ECHO", "--git_path='path'"])
end
