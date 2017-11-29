build_projects = %w(pi_build_modifier)
install_projects = %w(pi_customizer)
all_gems = (build_projects+install_projects).uniq
files = %w(pi_build_modifier/lib/**/*.rb pi_customizer/lib/**/*.rb)

##
# The spec task executes rspec tests for all gems of the pi_customizer project.
# This task is executed by default when 'rspec' is called.

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|

    pattern = ''
    all_gems.each do |gem|
      if pattern == ''
        pattern = "#{gem}/spec/**{,/*/**}/*_spec.rb"
      else
        pattern = pattern + ',' + "#{gem}/spec/**{,/*/**}/*_spec.rb"
      end
    end
    t.pattern = pattern
  end
rescue LoadError
  puts 'RSpec is not installed. This means rake is not able to execute tests! Try: '
  puts '* gem install rspec!'
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
  puts 'RSpec is not installed. This means rake is not able to build the documentation!'
  puts '* Try: gem install rdoc!'
end


# build tasks

desc 'Build all sub all_gems'
task :build do
  all_gems.each do |p|
    Dir.chdir p do
      system 'rake build'
    end
  end
end

namespace :uninstall do
  desc 'remove the locally required gems'
  task :local do
    install_projects.each do |p|
      Dir.chdir p do
        system "gem uninstall #{p} -a -x"
      end
    end
  end
end

namespace :install do

  require 'fileutils'

  desc 'install the locally required gems'
  task :local do
    build_projects.each do |p|
      Dir.chdir p do
        system 'rake build'
      end
    end
    install_projects.each do |p|
      Dir.chdir p do
        system 'rake install:local'
      end
    end
  end

  task :local => [:spec, :rdoc, 'uninstall:local']

end

# run the pi_customizer from source

namespace :run do

  desc 'run the pi_customizer and build the pi image in a vagrant box'
  task :vagrant, [:resources] do |t, args|
    system ("ruby pi_customizer/bin/pi_customizer build VAGRANT #{args[:resources]}")
  end

  desc 'run the pi_customizer and build the pi image in a docker container'
  task :docker, [:resources] do |t, args|
    system ("ruby pi_customizer/bin/pi_customizer build DOCKER #{args[:resources]}")
  end

end