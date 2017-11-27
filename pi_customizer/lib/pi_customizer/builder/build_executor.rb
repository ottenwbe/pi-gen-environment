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

require 'pi_customizer/environment/environment_builder_factory'

module PiCustomizer
  module Builder
    class BuildExecutor

      def initialize(environment, skip_build_steps)
        @env = environment
        @skip_build_steps = skip_build_steps
      end

      def check
        check_env
        @env.check
      end

      def prepare
        @env.prepare
      end

      def start
        @env.start
      end

      def build_image
        @env.build_image
      end

      def publish
        @env.publish
      end

      def clean_up
        @env.clean_up
      end

      def stop
        @env.stop
      end

      def ensure
        @env.ensure
      end

      private def check_env
        if @env.nil?
          raise 'No environment specified, please specify the "environment", e.g. Vagrant'
        end
      end
    end
  end
end