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

require 'pi_customizer/build/environment/environment'
require 'pi_customizer/build/environment/aws/aws'
require 'pi_customizer/build/environment/vagrant/vagrant'
require 'pi_customizer/build/environment/docker/docker'
require 'pi_customizer/build/builder/builder'
require 'pi_customizer/build/builder/prepare_start_execute_builder'
require 'pi_customizer/build/builder/start_prepare_execute_builder'
require 'pi_customizer/build/workspace/remote_workspace'
require 'pi_customizer/build/workspace/local_workspace'
require 'pi_customizer/utils/logex'


module PiCustomizer
  module Environment

    ENV_AWS = 'AWS'
    ENV_VAGRANT = 'VAGRANT'
    ENV_DOCKER = 'DOCKER'
    ENV_ECHO = 'ECHO'

    def Environment.environment_builder_factory(env, local_workspace, remote_workspace, skip_build_steps)

      environment = environment_factory(env, local_workspace, remote_workspace)

      case env
        when ENV_AWS, ENV_VAGRANT
          env_builder = Builder::PrepareExecuteBuilder.new(environment, skip_build_steps)
        when ENV_DOCKER, ENV_ECHO
          puts "Echo: - Git Path: #{remote_workspace.git_path}, Workspace Path: #{remote_workspace.workspace_directory}, Config Path: #{local_workspace.config_path}, #{skip_build_steps}"
          env_builder = Builder::StartExecuteBuilder.new(environment, skip_build_steps)
        else
          $logger.warn 'No valid build environment defined!'
          env_builder = Builder::PiBuilder.new(environment, skip_build_steps)
      end
      env_builder
    end

    def Environment.environment_factory(env, local_workspace, remote_workspace)
      case env
        when ENV_AWS
          environment = AWS.new(remote_workspace, local_workspace)
        when ENV_VAGRANT
          environment = Vagrant.new(remote_workspace, local_workspace)
        when ENV_DOCKER
          environment = Docker.new(remote_workspace, local_workspace)
        when ENV_ECHO
          environment = EnvironmentControl.new(remote_workspace, local_workspace)
        else
          $logger.info 'No valid environment (e.g., AWS or VAGRANT) defined!'
          environment = EnvironmentControl.new(remote_workspace, local_workspace)
      end
      environment
    end
  end
end
