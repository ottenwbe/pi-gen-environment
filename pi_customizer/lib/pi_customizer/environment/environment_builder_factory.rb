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

require 'pi_customizer/environment/vagrant'
require 'pi_customizer/environment/aws'
require 'pi_customizer/environment/environment'
require 'pi_customizer/builder/prepare_start_execute_builder'
require 'pi_customizer/builder/start_prepare_execute_builder'
require 'pi_customizer/builder/builder'
require 'pi_customizer/config/logex'

module PiCustomizer
  module Environment

    ENV_AWS = 'AWS'
    ENV_VAGRANT = 'VAGRANT'
    ENV_ECHO = 'ECHO'

    def Environment.environment_builder_factory(env, git_path, workspace_path, config_path)

      workspace = Workspace::Workspace.new(workspace_path, git_path)
      environment = environment_factory(env, config_path, workspace)

      case env
        when ENV_AWS
          env_builder = Builder::PrepareExecuteBuilder.new(environment)
        when ENV_VAGRANT
          env_builder = Builder::PrepareExecuteBuilder.new(environment)
        when ENV_ECHO
          puts "Echo: - Git Path: #{git_path}, Workspace Path: #{workspace_path}, Config Path: #{config_path}"
          env_builder = Builder::StartStopBuilder.new(environment)
        else
          $logger.warn 'No valid build environment defined!'
          env_builder = Builder::PiBuilder.new(environment)
      end
      env_builder
    end

    def Environment.environment_factory(env, config_path, workspace)
      case env
        when ENV_AWS
          environment = AWS.new(config_path, workspace)
        when ENV_VAGRANT
          environment = Vagrant.new(config_path, workspace)
        when ENV_ECHO
          environment = EnvironmentControl.new(config_path, workspace)
        else
          $logger.info 'NO valid environment (e.g., AWS or VAGRANT) defined!'
          environment = EnvironmentControl.new(config_path, workspace)
      end
      environment
    end
  end
end
