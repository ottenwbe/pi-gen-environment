# Copyright (c) 2017-2018 Beate Ottenwälder
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

require 'erb'
require 'fileutils'
require 'pi_customizer/build/workspace/remote_workspace'
require 'pi_customizer/build/workspace/local_workspace'

module PiCustomizer
  module Environment

    ##
    # VagrantFile describes the dynamic attributes of a Vagrantfile which is used to start up the vagrant environment

    class VagrantFile

      attr_accessor :vagrant_template_path, :disk_size, :config_file_destination, :workspace, :config

      def initialize(config, workspace)
        @vagrant_template_path = File.join(File.dirname(__FILE__), '/templates/Vagrantfile.erb')
        @disk_size = '40GB'
        @config_file_destination = '/vagrant/config.json'
        @config = if config.nil?
                    Workspace::LocalWorkspace.new
                  else
                    config
                  end
        @workspace = if workspace.nil?
                       Workspace::RemoteWorkspace.new
                     else
                       workspace
                     end
      end

      def get_binding
        binding
      end

    end


    class VagrantFileRenderer

      def initialize(vagrant_file)
        @vagrant_file = vagrant_file
      end

      def create_from_template
        check_dependencies
        read_template
        write_vagrantfile
      end

      private def check_dependencies
        unless File.file?(@vagrant_file.vagrant_template_path.to_s)
          raise "'Vagrantfile.erb' template not specified. Expected template in path '%s'" % [@vagrant_file.vagrant_template_path]
        end
      end

      private def read_template
        File.open(@vagrant_file.vagrant_template_path.to_s, 'r+') do |f|
          @template = f.read
        end
      end

      def render
        ERB.new(@template).result(@vagrant_file.get_binding)
      end

      private def write_vagrantfile
        FileUtils.mkdir_p @vagrant_file.config.workspace_directory
        File.open(@vagrant_file.config.workspace_directory.to_s + '/Vagrantfile', 'w+') do |f|
          f.write(render)
        end
      end
    end
  end
end
