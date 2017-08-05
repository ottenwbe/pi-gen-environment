require "fileutils"

class AWS

  def initialize
    unless File.directory?('ssh')
      FileUtils.mkdir_p 'ssh'
    end
  end

  def build
    create_keys
    puts 'Build env with terraform'
    Dir.chdir 'envs/aws' do
      system 'terraform plan'
      system 'terraform apply'
    end
  end

  def create_keys(key_name = 'pi-builder')
    puts 'Create AWS key unless it exists'
    unless File.file?("ssh/#{key_name}.pub")
      system "ssh-keygen -t rsa -C pi-builder -P '' -f ssh/#{key_name} -b 4096"
      FileUtils.mv "ssh/#{key_name}", "ssh/#{key_name}.pem"
      FileUtils.chmod 400, "ssh/#{key_name}.pem"
    end
  end

  def del_keys(key_name = 'pi-builder')
    if File.file?("ssh/#{key_name}.pub")
      FileUtils.rm "ssh/#{key_name}.pub"
    end
    if File.file?("ssh/#{key_name}.pem")
      FileUtils.rm "ssh/#{key_name}.pem"
    end
  end

end
