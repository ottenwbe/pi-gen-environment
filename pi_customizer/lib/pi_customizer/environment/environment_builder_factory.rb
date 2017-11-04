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

require 'pi_customizer/environment/environment'
require 'pi_customizer/environment/aws/aws'
require 'pi_customizer/environment/vagrant/vagrant'
require 'pi_customizer/environment/docker/docker'
require 'pi_customizer/builder/builder'
require 'pi_customizer/builder/prepare_start_execute_builder'
require 'pi_customizer/builder/start_prepare_execute_builder'
require 'pi_customizer/workspace/workspace'
require 'pi_customizer/workspace/local_config'
require 'pi_customizer/utils/logex'


module PiCustomizer
  module Environment

    ENV_AWS = 'AWS'
    ENV_VAGRANT = 'VAGRANT'
    ENV_DOCKER = 'DOCKER'
    ENV_ECHO = 'ECHO'

    def Environment.environment_builder_factory(env, git_path, workspace_directory, config_path, tmp_directory)

      workspace = Workspace::Workspace.new(workspace_directory, git_path)
      local_config = Workspace::LocalConfig.new(config_path, tmp_directory)
      environment = environment_factory(env, local_config, workspace)

      case env
        when ENV_AWS, ENV_VAGRANT
          env_builder = Builder::PrepareExecuteBuilder.new(environment)
        when ENV_DOCKER, ENV_ECHO
          puts "Echo: - Git Path: #{git_path}, Workspace Path: #{workspace_directory}, Config Path: #{config_path}"
          env_builder = Builder::StartStopBuilder.new(environment)
        else
          $logger.warn 'No valid build environment defined!'
          env_builder = Builder::PiBuilder.new(environment)
      end
      env_builder
    end

    def Environment.environment_factory(env, local_config, workspace)
      case env
        when ENV_AWS
          environment = AWS.new(workspace, local_config)
        when ENV_VAGRANT
          environment = Vagrant.new(workspace, local_config )
        when ENV_DOCKER
          environment = Docker.new(workspace, local_config)
        when ENV_ECHO
          environment = EnvironmentControl.new(workspace, local_config)
        else
          $logger.info 'NO valid environment (e.g., AWS or VAGRANT) defined!'
          environment = EnvironmentControl.new(workspace, local_config)
      end
      environment
    end
  end
end
