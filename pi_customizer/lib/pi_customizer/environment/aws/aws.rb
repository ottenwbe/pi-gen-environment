# Copyright (c) 2017 Beate Ottenwälder
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'fileutils'
require 'pi_customizer/utils/logex'
require 'pi_customizer/environment/environment'

module PiCustomizer
  module Environment
    class AWS < EnvironmentControl

      def build

        puts 'NOTE: AWS is not yet officially supported!'

        create_ssh_folder
        create_keys
        begin
          terraform
        ensure
          del_keys
        end
      end

      def terraform
        puts 'Build env with terraform'
        Dir.chdir 'envs/aws' do
          system 'terraform plan'
          system 'terraform apply'
        end
      end

      def create_keys(key_name = 'pi-builder')
        $logger.info 'Create AWS key unless it exists'
        FileUtils.mkdir_p 'ssh'
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

      def create_ssh_folder
        unless File.directory?('ssh')
          FileUtils.mkdir_p 'ssh'
        end
      end
    end
  end
end
