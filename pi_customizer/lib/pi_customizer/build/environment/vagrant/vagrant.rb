# Copyright (c) 2017-2019 Beate Ottenwälder
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
require 'pi_customizer/build/environment/vagrant/vagrant_file'
require 'pi_customizer/build/environment/environment'
require 'pi_customizer/utils/logex'

module PiCustomizer
  module Environment
    class Vagrant < EnvironmentControl

      VAGRANT_SOURCE = File.join(File.dirname(__FILE__), '/templates')

      def check
        $logger.info '[Check] Pre-flight checks are executing...'
        ensure_vagrant
      end

      def prepare
        $logger.info '[Prepare] pi-image in vagrant environment'
        VagrantFileRenderer.new(VagrantFile.new(@config, @workspace)).create_from_template
      end

      def start
        $logger.info '[Start] pi-image in local vagrant environment'
        Dir.chdir(@config.workspace_directory) do
          system 'vagrant destroy -f' # cleanup old environment
          system 'vagrant up --provider=virtualbox --no-provision'
        end
      end

      def build_image
        $logger.info '[Build] pi-image in local vagrant environment'
        Dir.chdir(@config.workspace_directory) do
          system 'vagrant provision'
        end
      end

      def clean_up
        $logger.info '[Clean Up] pi-image in local vagrant environment'
      end

      def stop
        $logger.info '[Stop] pi-image in local vagrant environment'
        Dir.chdir(@config.workspace_directory) do
          system 'vagrant destroy -f'
        end
      end

      def ensure_vagrant
        unless system 'vagrant -v'
          raise 'Vagrant not installed. Please ensure that vagrant is installed correctly.'
        end
      end
    end

  end
end

