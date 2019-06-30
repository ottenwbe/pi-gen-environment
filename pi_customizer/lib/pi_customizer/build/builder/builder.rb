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

require 'pi_customizer/build/builder/build_executor'

module PiCustomizer
  module Builder

    ##
    # PiBuilder abstractly defines the steps of a build process.
    # However, the concrete orchestration of the build process's steps is done by its sub-classes.

    class PiBuilder

      ##
      # build orchestrates the build steps related to an environment and therefore the build process of an image

      def build(environment, build_config)
        build_executor = BuildExecutor.new(environment, build_config)
        begin
          execute_builder(build_executor)
        rescue Exception => e
          $logger.error e.message
        ensure
          ensure_builder(build_executor)
        end
      end

      private def execute_builder(build_executor)
        build_executor.check
        build_executor.prepare
        build_executor.start
        build_executor.build_image
        build_executor.publish
        build_executor.stop
        build_executor.clean_up
      end

      private def ensure_builder(build_executor)
        build_executor.ensure
      end

    end

  end
end