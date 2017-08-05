require_relative 'lib/pi-gen-environment'

task :default => :run_vagrant

task :run_vagrant do
  PiGen.start(["build","VAGRANT"])
end

task :run_echo do
  PiGen.start(["build","ECHO"])
end

task :run_echo_git do
  PiGen.start(["build","ECHO","--git_path='path'"])
end
