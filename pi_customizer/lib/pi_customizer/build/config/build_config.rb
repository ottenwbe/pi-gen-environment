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

module PiCustomizer
  module Config

    ##
    # BuildConfig holds all configurations for the build execution

    class BuildConfig
      attr_reader :skip_build_steps

      def initialize(skip_build_steps = Array.new)
        @skip_build_steps = convert_to_skip(skip_build_steps)
      end

      ##
      # check if a build step needs to be skipped

      def skip?(build_step)
        @skip_build_steps.include? build_step
      end

      ##
      # convert a list of stringified build steps to a list of symbols

      private def convert_to_skip(skip_build_steps)
        if skip_build_steps.nil?
          skip_build_steps = Array.new
        else
          # convert every key to a symbol
          skip_build_steps = skip_build_steps.collect(&:to_sym)
        end
        $logger.debug "Skipping the following build steps: #{skip_build_steps}"
        skip_build_steps
      end
    end

  end
end