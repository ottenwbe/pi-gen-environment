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

require_relative 'vagrant'
require_relative 'aws'
require_relative 'environment'

module PiCustomizer
  module Environment

    ENV_AWS = 'AWS'
    ENV_VAGRANT = 'VAGRANT'
    ENV_ECHO = 'ECHO'

    def Environment.environment_factory(workspace, env, git_path, space)
      case env
        when ENV_AWS
          env = AWS.new
        when ENV_VAGRANT
          env = Vagrant.new
        when ENV_ECHO
          puts "Echo: - Git Path: #{git_path} and Workspace Path: #{space}"
          env = EnvironmentControl.new
        else
          $logger.info 'NO valid build environment (AWS or VAGRANT) defined!'
          env = EnvironmentControl.new
      end
      env
    end
  end
end
