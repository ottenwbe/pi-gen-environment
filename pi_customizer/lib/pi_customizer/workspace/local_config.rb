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

module PiCustomizer
  module Workspace
    class LocalConfig

      DEFAULT_CONFIG_PATH = File.join(File.dirname(__FILE__), '/../../../envs/config.json')
      DEFAULT_TMP_DIRECTORY = Dir.getwd + '/tmp'

      attr_reader :config_path, :tmp_directory

      def initialize(config_path = DEFAULT_CONFIG_PATH, tmp_directory = DEFAULT_TMP_DIRECTORY)
        $logger.debug "Local Config at '#{config_path}' with tmp dir '#{tmp_directory}'"
        @config_path = if config_path.nil? or config_path == ''
                         DEFAULT_CONFIG_PATH
                       else
                         config_path.to_s
                       end
        @tmp_directory = if tmp_directory.nil? or tmp_directory == ''
                           DEFAULT_TMP_DIRECTORY
                         else
                           tmp_directory.to_s
                         end
        $logger.debug "Local Config at '#{@config_path}' with tmp dir '#{@tmp_directory}'"
      end

    end
  end
end
