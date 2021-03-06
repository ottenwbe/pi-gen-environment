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
require 'pi_customizer/utils/logex'

module PiCustomizer
  module Workspace

    ##
    # the default directory at the build environment where the build sources are cloned to

    DEFAULT_REMOTE_WORKSPACE_DIRECTORY = '/build/pi-gen'

    ##
    # the default directory for the build sources

    DEFAULT_GIT_PATH = 'https://github.com/ottenwbe/pi-gen.git'

    ##
    # the default directory for the build sources

    DEFAULT_GIT_TAG = 'master'

    ##
    # The RemoteWorkspace class encapsulates the configuration of the config in the build environment

    class RemoteWorkspace

      attr_reader :git_path, :workspace_directory, :git_tag

      def initialize(workspace_dir = '', git_path = '', git_tag = '')
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
        @git_tag = if git_tag.nil? or git_tag == ''
                     DEFAULT_GIT_TAG
                   else
                     git_tag.to_s
                   end
        $logger.debug
        "Remote Workspace:\ndir='#{@workspace_directory}'\ngit-url='#{@git_path}'\ngit-tag=#{@git_tag}"
      end

      ##
      # Checks for value equality between a pair of RemoteWorkspace's attributes

      def ==(other)
        (@git_path == other.git_path) && (@workspace_directory == other.workspace_directory) && (@git_tag == other.git_tag)
      end

    end
  end
end


