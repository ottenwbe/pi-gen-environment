build_projects = %w(pi_build_modifier)
install_projects = %w(pi_customizer)
projects = (build_projects+install_projects).uniq
files = %w(pi_build_modifier/lib/**/*.rb pi_customizer/lib/**/*.rb)

# test tasks

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|

    pattern = ''
    projects.each do |p|
      if pattern == ''
        pattern = "#{p}/spec/**{,/*/**}/*_spec.rb"
      else
        pattern = pattern + ',' + "#{p}/spec/**{,/*/**}/*_spec.rb"
      end
    end
    t.pattern = pattern
  end
rescue LoadError
  puts 'RSpec is not installed. This means rake is not able to execute tests! Execute: gem install rspec!'
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
  puts 'RSpec is not installed. This means rake is not able to build the documentation! Execute: gem install rdoc!'
end


# build tasks

desc 'Build all sub projects'
task :build do
  projects.each do |p|
    Dir.chdir p do
      system 'rake build'
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
        #TODO: uplaod gem to a server
        FileUtils.mv('pkg/pi_build_modifier-0.1.0.gem', '../pi_customizer/envs/pi_build_modifier.gem')
      end
    end
    install_projects.each do |p|
      Dir.chdir p do
        system 'rake install:local'
      end
    end
  end

  task :local => [:spec, :rdoc]

end

# run the application

namespace :run do

  desc 'run the pi_customizer and build the pi image in a docker container'
  task :docker, [:config] do |t, args|
    system ("ruby pi_customizer/bin/pi_customizer build DOCKER #{args[:config]}")
  end

end