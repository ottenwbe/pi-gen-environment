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
require 'pi_customizer/build/builder/build_executor'

module PiCustomizer
  module Builder

    ##
    # PiBuilder defines abstractly the steps of a build process.
    # However, the concrete orchestration of the build process's steps is done by its sub-classes.

    class PiBuilder

      attr_reader :build_executor

      def initialize(environment, skip_build_steps)
        @build_executor = BuildExecutor.new(environment,skip_build_steps)
      end

      def build
        begin
          execute_builder
        rescue Exception => e
          $logger.error e.message
        ensure
          ensure_builder
        end
      end

      protected def ensure_builder
      end

      protected def execute_builder
      end

    end
  end
end