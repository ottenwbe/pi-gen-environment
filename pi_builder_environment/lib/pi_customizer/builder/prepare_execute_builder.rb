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

require_relative '../environment/environment_factory'
require_relative '../workspace/workspace'
require_relative 'builder'

module PiCustomizer
  module Builder
    class PrepareExecuteBuilder < PiBuilder

      def build
        prepare
        execute
        stop
      end

      def start
        if environmentName.nil?
          $logger.error('No environment specified, please specify the "environmentName"')
          return
        end

        @workspace = Workspace::Workspace.new(workspace_dir: options[:workspace], git_location: options[:git_path])
        @env = Environment.environment_factory(workspace, environmentName, "#{options[:git_path]}", "#{options[:workspace]}")
        @env.workspace = workspace

        @env.start
        @env.prepare

      end

      def stop
        @workspace.clean_up
        @env.stop
      end

      def execute
        @workspace.get_or_refresh
        @env.prepare_image
        @env.build_image
        @env.deploy_image
      end
    end
  end
end