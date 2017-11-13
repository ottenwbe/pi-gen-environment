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
require 'pathname'
require 'pi_customizer/utils/logex'

module PiCustomizer
  module Workspace

    ##
    # The default path which points to the configuration file

    DEFAULT_CONFIG_PATH = File.join(File.dirname(__FILE__), '/../../../envs/config.json')

    ##
    # The default directory which is used to store temporary build files, e.g., the Vagrantfile for a build with vagrant

    DEFAULT_TMP_DIRECTORY = Dir.pwd + '/tmp'

    ##
    # The LocalWorkspace class encapsulates the configuration of the workspace on the machine where the build of the pi image is triggered

    class LocalWorkspace

      attr_reader :config_path, :tmp_directory, :modifier_gem_path

      def initialize(config_path = '', tmp_directory = '', modifier_gem_path = '')
        self.config_path = config_path
        self.tmp_directory = tmp_directory
        self.modifier_gem_path = modifier_gem_path
        $logger.debug "Local Workspace is at '#{@config_path}' with tmp directory '#{@tmp_directory}' and modifier_gem_path '#{@modifier_gem_path}'"
      end

      ##
      # Checks for value equality between a pair of LocalWorkspace's attributes

      def ==(other)
        (@tmp_directory == other.tmp_directory) && (@modifier_gem_path == other.modifier_gem_path) && (@config_path == other.config_path)
      end

      private def config_path=(config_path)
        @config_path = if config_path.nil? or config_path == ''
                         Pathname.new(DEFAULT_CONFIG_PATH)
                       else
                         absolute_path_name(config_path)
                       end
      end

      private def tmp_directory=(tmp_directory)
        @tmp_directory = if tmp_directory.nil? or tmp_directory == ''
                           Pathname.new(DEFAULT_TMP_DIRECTORY)
                         else
                           absolute_path_name(tmp_directory)
                         end
      end

      private def modifier_gem_path=(modifier_gem_path)
        @modifier_gem_path = if modifier_gem_path.nil? or modifier_gem_path == ''
                               nil
                             else
                               absolute_path_name(modifier_gem_path)
                             end
      end

      private def absolute_path_name(path)
        tmp_path = Pathname.new(path)
        if tmp_path.relative?
          tmp_path = File.expand_path(path, Dir.pwd)
        end
        tmp_path
      end
    end
  end
end
