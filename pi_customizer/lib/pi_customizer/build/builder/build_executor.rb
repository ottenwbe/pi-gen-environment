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

      ##
      # check if a build environment is specified and then calls the check step for this environment

      def check
        check_env
        @env.check
      end

      ##
      # execute the prepare step for the build environment

      def prepare
        unless @skip_build_steps.include?(:prepare)
          @env.prepare
        end
      end

      ##
      # execute the start step for the build environment

      def start
        unless @skip_build_steps.include?(:start)
          @env.start
        end
      end

      ##
      # execute the build_image step for the build environment

      def build_image
        unless @skip_build_steps.include?(:build_image)
          @env.build_image
        end
      end

      ##
      # publish the image from the build environment

      def publish
        unless @skip_build_steps.include?(:publish)
          @env.publish
        end
      end

      ##
      # clean_up the build environment

      def clean_up
        unless @skip_build_steps.include?(:clean_up)
          @env.clean_up
        end
      end

      ##
      # execute the stop step of the environment

      def stop
        unless @skip_build_steps.include?(:stop)
          @env.stop
        end
      end

      ##
      # execute the ensure step of an environment

      def ensure
        @env.ensure
      end

      ##
      # convert a list of stringified build steps to a list of symbols

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

      ##
      # check if an environment is specified

      private def check_env
        if @env.nil?
          raise 'No environment specified, please specify the "environment", e.g. Vagrant'
        end
      end
    end
  end
end

















