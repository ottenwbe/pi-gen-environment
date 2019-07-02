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
require 'pi_customizer/build/environment/environment'
require 'pi_customizer/build/config/build_config'

module PiCustomizer
  module Builder

    ##
    # BuildExecutor triggers the steps of a build process for a given environment (e.g., a vagrant box).
    # It skips individual steps in the build process when they are defined as skip_build_steps.

    class BuildExecutor

      attr_reader :env

      def initialize(environment, build_config)
        @env = environment
        @build_config = build_config
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
        unless @build_config.skip?(:prepare)
          @env.prepare
        end
      end

      ##
      # execute the start step for the build environment

      def start
        unless @build_config.skip?(:start)
          @env.start
        end
      end

      ##
      # execute the build_image step for the build environment

      def build_image
        unless @build_config.skip?(:build_image)
          @env.build_image
        end
      end

      ##
      # publish the image from the build environment

      def publish
        unless @build_config.skip?(:publish)
          @env.publish
        end
      end

      ##
      # clean_up the build environment

      def clean_up
        unless @build_config.skip?(:clean_up)
          @env.clean_up
        end
      end

      ##
      # execute the stop step of the environment

      def stop
        unless @build_config.skip?(:stop)
          @env.stop
        end
      end

      ##
      # execute the ensure step of an environment

      def ensure
        @env.ensure
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

















