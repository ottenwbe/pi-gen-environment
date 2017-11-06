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

require 'erb'
require 'fileutils'
require 'pi_customizer/workspace/workspace'

module PiCustomizer
  module Environment
    class VagrantFile

      attr_accessor :vagrant_path, :disk_size, :config_file_destination, :config_file_source, :workspace, :git_path

      def initialize(config_path, workspace)
        @vagrant_path = File.join(File.dirname(__FILE__), '/../../../../envs/vagrant/')
        @disk_size = '20GB'
        @config_file_destination = '~/conf.json'
        if config_path.nil? || config_path.empty?
          @config_file_source = 'conf.json'
        else
          @config_file_source = config_path
        end
        if workspace.nil?
          @git_path = Workspace::Workspace::DEFAULT_GIT_PATH
          @workspace = Workspace::Workspace::DEFAULT_WORKSPACE_DIRECTORY
        else
          @git_path = workspace.git_path
          @workspace = workspace.workspace_directory
        end
      end

      def get_binding
        binding
      end

    end
  end

  class VagrantFileRenderer

    def initialize(vagrant_file)
      @vagrant_file = vagrant_file
    end

    def create_from_template
      check_dependencies
      read_template
      write_rendered
    end

    private def check_dependencies
      unless File.file?(@vagrant_file.vagrant_path.to_s + 'Vagrantfile.erb')
        raise "'Vagrantfile.erb' template not specified. Searching in path '%s'" % [@vagrant_file.vagrant_path]
      end
    end

    private def read_template
      File.open(@vagrant_file.vagrant_path.to_s + 'Vagrantfile.erb', 'r+') do |f|
        @template = f.read
      end
    end

    def render
      ERB.new(@template).result(@vagrant_file.get_binding)
    end

    private def write_rendered
      File.open(@vagrant_file.vagrant_path.to_s + 'Vagrantfile', 'w+') do |f|
        f.write(render)
      end
    end

  end
end
