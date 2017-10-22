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
require_relative '../config/logex'

module PiCustomizer
  module Workspace
    class Workspace

      DEFAULT_WORKSPACE_DIRECTORY = '../pi-gen'
      DEFAULT_GIT_PATH = 'https://github.com/ottenwbe/pi-gen.git'

      def initialize(workspace_dir = DEFAULT_WORKSPACE_DIRECTORY, git_path = DEFAULT_GIT_PATH)
        $logger.info "Creating workspace at '#{workspace_dir}' from '#{git_path}'"
        @workspace_directory = if workspace_dir.nil? or workspace_dir == ''
                                 DEFAULT_WORKSPACE_DIRECTORY
                               else
                                 workspace_dir.to_s
                               end
        @git_path = if git_path.nil? or git_path == ''
                      DEFAULT_GIT_PATH
                    else
                      git_path.to_s
                    end
        $logger.info "Creating workspace at '#{@workspace_directory}' from '#{@git_path}'"
      end

      def do_work
        get_or_refresh
        yield
        clean_up
      end

      def get_or_refresh
        if File.directory?(@workspace_directory)
          system "git pull #{@workspace_directory} -r"
        else
          system "git clone #{@git_path} #{@workspace_directory}"
        end
      end

      def clean_up
        FileUtils.rm_rf @workspace_directory
      end
    end
  end
end


