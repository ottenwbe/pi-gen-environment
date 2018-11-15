PI_CUSTOMIZER = 'pi_customizer'
PI_BUILD_MODIFIER = 'pi_build_modifier'

build_projects = [PI_CUSTOMIZER]
install_projects = [PI_BUILD_MODIFIER]
all_gems = (build_projects+install_projects).uniq
files = %w(pi_build_modifier/lib/**/*.rb pi_customizer/lib/**/*.rb)

##
# The spec task executes rspec tests for all gems of the pi_customizer project.
# This task is executed by default when 'rake' is called on the command line

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    # find all spec files (for all gems)
    pattern = ''
    all_gems.each do |gem|
      if pattern == ''
        pattern = "#{gem}/spec/**{,/*/**}/*_spec.rb"
      else
        pattern = pattern + ',' + "#{gem}/spec/**{,/*/**}/*_spec.rb"
      end
    end
    # tell rspec to execute tests on all spec files
    t.pattern = pattern
  end
rescue LoadError
  puts 'RSpec is not installed. This means rake is not able to execute tests! Try: '
  puts '* gem install rspec!'
end

task :default => :spec

# acceptance testing

desc 'Run acceptance tests by building an image and starting it in QEMU.
      NOTE: Use with caution. Makes changes to your local file system.'
task :acceptance do

  #TODO: create qemu environments
  Dir.mkdir_p '/mnt/custompi'

  #system 'pi_customizer build VAGRANT --modifier-gem=pi_build_modifier/pkg/pi_build_modifier-0.3.0.pre.alpha.gem'
  Dir.chdir 'tmp/deploy' do
    d = DateTime.now
    image_name = d.strftime('%Y-%m-%d-custompi-lite')
    system 'unzip -f image_' + image_name + '.zip'
    system 'qemu-system-arm -kernel ~/VMs/qemu/kernel-qemu-4.4.34-jessie -cpu arm1176 -m 256 -M versatilepb -serial stdio -append "root=/dev/sda2 rootfstype=ext4 rw" -hda ' + image_name + '.img -redir tcp:5022::22 -no-reboot'
  end
end

task :acceptancrae => [:spec, 'install:local']

# release task

desc 'Release and upload to Rubygems.org'
task :release do
  all_gems.each do |p|
    Dir.chdir p do
      system 'rake release'
    end
  end
end

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

desc "Build all gems (i.e., #{PI_BUILD_MODIFIER} and #{PI_CUSTOMIZER})"
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