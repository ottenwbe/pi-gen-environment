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

require 'pi_customizer/build/environment/builder_factory'
require 'pi_customizer/utils/logex'

module PiCustomizer
  module Builder

    ##
    # BuildExecutor triggers the steps of a build process in a given environment (e.g., a vagrant box).
    # It skips individual steps in the build process when they are defined as skip_build_steps.

    class BuildExecutor

      attr_reader :env, :skip_build_steps

      def initialize(environment, skip_build_steps = Array.new)
        @env = environment
        @skip_build_steps = convert_to_skip(skip_build_steps)
      end

      def check
        check_env
        @env.check
      end

      def prepare
        unless @skip_build_steps.include?(:prepare)
          @env.prepare
        end
      end

      def start
        unless @skip_build_steps.include?(:start)
          @env.start
        end
      end

      def build_image
        unless @skip_build_steps.include?(:build_image)
          @env.build_image
        end
      end

      def publish
        unless @skip_build_steps.include?(:publish)
          @env.publish
        end
      end

      def clean_up
        unless @skip_build_steps.include?(:clean_up)
          @env.clean_up
        end
      end

      def stop
        unless @skip_build_steps.include?(:stop)
          @env.stop
        end
      end

      def ensure
        @env.ensure
      end

      private def convert_to_skip(skip_build_steps)
        if skip_build_steps.nil?
          skip_build_steps = Array.new
        else
          # convert every key to a symbol
          skip_build_steps = skip_build_steps.collect {|k| k.to_sym}
        end
        $logger.debug "Skipping the following build steps: #{skip_build_steps}"
        skip_build_steps
      end

      private def check_env
        if @env.nil?
          raise 'No environment specified, please specify the "environment", e.g. Vagrant'
        end
      end
    end
  end
end

















