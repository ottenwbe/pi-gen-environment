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

require 'fileutils'
require 'pi_customizer/utils/logex'

module PiCustomizer
  module Workspace

    DEFAULT_REMOTE_WORKSPACE_DIRECTORY = '/build/pi-gen'
    DEFAULT_GIT_PATH = 'https://github.com/ottenwbe/pi-gen.git'

    ##
    # The RemoteWorkspace class encapsulates the configuration of the workspace in the build environment

    class RemoteWorkspace

      attr_reader :git_path, :workspace_directory

      def initialize(workspace_dir = '', git_path = '')
        @workspace_directory = if workspace_dir.nil? or workspace_dir == ''
                                 DEFAULT_REMOTE_WORKSPACE_DIRECTORY
                               else
                                 workspace_dir.to_s
                               end
        @git_path = if git_path.nil? or git_path == ''
                      DEFAULT_GIT_PATH
                    else
                      git_path.to_s
                    end
        $logger.debug "Workspace at '#{@workspace_directory}' with sources from '#{@git_path}'"
      end

      ##
      # Checks for value equality between a pair of RemoteWorkspace's attributes

      def ==(other)
        (@git_path == other.git_path) && (@workspace_directory == other.workspace_directory)
      end

    end
  end
end


