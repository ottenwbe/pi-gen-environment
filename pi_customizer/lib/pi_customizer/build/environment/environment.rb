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

require 'pi_customizer/utils/logex'

module PiCustomizer
  module Environment

    ##
    # EnvironmentControl defines the lifecycle steps of a build environment 

    class EnvironmentControl

      attr_reader :workspace, :config

      def initialize(remote_workspace, local_workspace)
        @workspace = remote_workspace
        @config = local_workspace
      end

      def check
        $logger.warn '[Check] skipped...'
      end

      def prepare
        $logger.warn '[Prepare] skipped...'
      end

      def start
        $logger.warn '[Start] skipped...'
      end

      def build_image
        $logger.warn '[Build Image] skipped...'
      end

      def publish
        $logger.warn '[Publish] skipped...'
      end

      def clean_up
        $logger.warn '[Clean up] skipped...'
      end

      def stop
        $logger.warn '[Stop] skipped...'
      end

      def ensure
        $logger.info '[Ensure] skipped...'
      end

    end
  end
end

