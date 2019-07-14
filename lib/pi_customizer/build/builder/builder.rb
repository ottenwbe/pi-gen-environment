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
  module Builder

    ##
    # PiBuilder defines the life-cycle steps of a pi image build process.
    # More precisely it ensures that a build environment is up and running and then triggers the build in it
    # before cleaning everything up.

    class PiBuilder

      attr_reader :env

      def initialize(environment, build_config)
        @env = environment
        @build_config = build_config
      end

      ##
      # build orchestrates the build steps and therefore the build process of an image

      def build
        begin
          execute_builder
        rescue Exception => e
          $logger.error e.message
        ensure
          ensure_builder
        end
      end

      private def execute_builder
        check
        prepare
        start
        modify
        build_image
        publish
        stop
        clean_up
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
      # execute the start step for the build environment

      def modify
        unless @build_config.skip?(:modify)
          @env.modify
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

      def ensure_builder
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