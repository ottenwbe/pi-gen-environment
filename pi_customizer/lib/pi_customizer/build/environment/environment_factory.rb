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

require 'pi_customizer/build/environment/environment'
require 'pi_customizer/build/environment/aws/aws'
require 'pi_customizer/build/environment/vagrant/vagrant'
require 'pi_customizer/build/environment/docker/docker'
require 'pi_customizer/build/config/remote_workspace'
require 'pi_customizer/build/config/local_workspace'
require 'pi_customizer/utils/logex'


module PiCustomizer
  module Environment

    ENV_AWS = 'AWS'
    ENV_VAGRANT = 'VAGRANT'
    ENV_DOCKER = 'DOCKER'
    ENV_ECHO = 'ECHO'

    ##
    # The environment_factory creates an environment controller tailored to the selected build environment env

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
        $logger.warn 'No valid environment (e.g., DOCKER or VAGRANT) defined!'
        environment = EnvironmentControl.new(remote_workspace, local_workspace)
      end
      environment
    end
  end
end
