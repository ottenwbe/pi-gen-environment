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
require_relative 'vagrant_file'
require 'pi_customizer/utils/logex'
require 'pi_customizer/environment/environment'

module PiCustomizer
  module Environment
    class Vagrant < EnvironmentControl

      VAGRANT_PATH = File.join(File.dirname(__FILE__), '/../../../../envs/vagrant')

      def check
        $logger.info '[Check] Pre-flight checks are executing...'
        ensure_vagrant
      end

      def prepare
        $logger.info '[Prepare] pi-image in vagrant environment'
        VagrantFileRenderer.new(VagrantFile.new(@workspace, @config_path)).create_from_template
      end

      def start
        $logger.info '[Start] pi-image in local vagrant environment'
        Dir.chdir(VAGRANT_PATH) do
          system 'vagrant destroy -f' # cleanup old environment
          system 'vagrant up --provider=virtualbox --no-provision'
        end
      end

      def build_image
        system 'vagrant provision'
        #TODO: push finished product to some destination, e.g. an S3 bucket
      end

      def clean_up
        $logger.info '[Clean Up] pi-image in local vagrant environment'
        # TODO: remove old files in Vagrant box?
      end

      def stop
        $logger.info '[Stop] pi-image in local vagrant environment'
        Dir.chdir(VAGRANT_PATH) do
          system 'vagrant destroy -f'
        end
      end

=begin
      def build
        $logger.info 'Building pi-image in local vagrant environment'
        Dir.chdir(VAGRANT_PATH) do
          system 'vagrant destroy -f'
          system 'vagrant up --provider=virtualbox --provision'
        end
      end
=end

      def ensure_vagrant
        unless system 'vagrant -v'
          raise 'Vagrant not installed. Please ensure that vagrant is installed correctly.'
        end
      end
    end

  end
end

