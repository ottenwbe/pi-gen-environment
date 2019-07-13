PI_CUSTOMIZER = 'pi_customizer'
files = %w(lib/**/*.rb)

##
# Enable gem tasks

require 'bundler/gem_tasks'

##
# The spec task executes rspec tests for all gems of the pi_customizer project.
# This task is executed by default when 'rake' is called on the command line

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

rescue LoadError
  puts 'RSpec is not installed. This means rake is not able to execute tests! '
  puts '* Try: gem install rspec'
end

task :default => :spec

# doc tasks

begin
  require 'rdoc/task'

  RDoc::Task.new do |rdoc|
    rdoc.rdoc_dir = File.join(File.dirname(__FILE__), '/doc')
    rdoc.rdoc_files.include(files)
  end
rescue LoadError
  puts 'RDoc is not installed. This means rake is not able to build the documentation!'
  puts '* Try: gem install rdoc'
end

# version tasks

desc "Show the gem's versions"
task :versions do
  require_relative "lib/#{PI_CUSTOMIZER}/version"
  puts "#{PI_CUSTOMIZER} Versions"
  puts ' '
  puts '*** Dev VERSION ***'
  puts ' '
  puts "#{PI_CUSTOMIZER}: #{PiCustomizer::VERSION} "
  system "gem list #{PI_CUSTOMIZER} --pre --remote"
  puts ' '
end


namespace :uninstall do
  desc 'remove the locally required gems'
  task :local do
    system "gem uninstall #{PI_CUSTOMIZER} -a -x"
  end
end

namespace :install do
  task :local => [:spec, :rdoc, 'uninstall:local']
end

# run the pi_customizer from source

namespace :run do

  desc 'run the pi_customizer and build the pi image in a vagrant box'
  task :vagrant, [:resources] do |t, args|
    system ("ruby bin/pi_customizer build VAGRANT #{args[:resources]}")
  end

  desc 'run the pi_customizer and build the pi image in a docker container'
  task :docker, [:resources] do |t, args|
    system ("ruby bin/pi_customizer build DOCKER #{args[:resources]}")
  end

end