require "thor"
require "fileutils"

class Vagrant
  def build
    Dir.chdir('src/vagrant') do
      exec('vagrant destroy -f
      vagrant up --provider=virtualbox --provision')
    end
  end
end

class AWS
  def build
    createAWSKeys
    puts 'Build env with terraform'
    Dir.chdir 'src/aws' do
      exec('terraform plan
      terraform apply')
    end
  end

  def createAWSKeys
    puts 'Create AWS key unless it exists'
    unless File.file?('ssh/pi-builder.pub')
      exec('ssh-keygen -t rsa -C pi-builder -P \'\' -f ssh/pi-builder -b 4096')
      FileUtils.mv 'ssh/pi-builder', 'ssh/pi-builder.pem'
      FilUtils.chmod 400, 'ssh/pi-builder.pem'
    end
  end

end

class PiGen < Thor

  desc "build ENV", "Build pi image on ENV (options are AWS or VAGRANT)."
  option :git_path
  option :local_path
  def build(env)
    puts "Build Image using environment: #{env}"

    case env
      when "AWS"
        AWS.new.build
      when "VAGRANT"
        Vagrant.new.build
      when "ECHO"
        puts "Git Path: #{options[:git]}"
      else
        puts "NO valid build environment (AWS or VAGRANT) defined!"
    end
  end
end

PiGen.start(ARGV)