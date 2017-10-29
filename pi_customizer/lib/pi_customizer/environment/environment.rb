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

require 'pi_customizer/config/logex'

module PiCustomizer
  module Environment
    class EnvironmentControl

      attr_reader :workspace, :config_path

      def initialize(workspace, config_path)
        @workspace = workspace
        @config_path = config_path
      end

      def check
        $logger.warn '[Check] Pre-flight checks are skipped...'
      end

      def prepare
        $logger.warn '[Prepare] Preparation steps are skipped...'
      end

      def start
        $logger.warn '[Start] Environment is not started...'
      end

      def build_image
        $logger.warn '[Build Image] Missing build_image command'
      end

      def clean_up
        $logger.warn '[Clean up] Missing clean_up command'
      end

      def stop
        $logger.warn '[Stop] Missing stop command'
      end

    end
  end
end

