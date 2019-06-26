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

require 'pi_customizer/build/builder/builder'
require 'pi_customizer/build/builder/prepare_start_execute_builder'
require 'pi_customizer/build/builder/start_prepare_execute_builder'
require 'pi_customizer/build/environment/environment_factory'
require 'pi_customizer/build/config/build_config'

module PiCustomizer
  module Builder

    ##
    # The builder_factory creates a builder for the selected environment env. The builder orchestrates the environment and the build process in the environment.

    def Builder.builder_factory(env, local_workspace, remote_workspace, skip_build_steps)

      build_config = Config::BuildConfig.new(skip_build_steps)
      environment = Environment::environment_factory(env, local_workspace, remote_workspace)

      case env
      when Environment::ENV_AWS, Environment::ENV_VAGRANT
        env_builder = PrepareExecuteBuilder.new(environment, build_config)
      when Environment::ENV_DOCKER, Environment::ENV_ECHO
        #puts "Echo: - Git Path: #{remote_workspace.git_path}, Workspace Path: #{remote_workspace.workspace_directory}, Config Path: #{local_workspace.config_path}, #{skip_build_steps}"
        env_builder = StartExecuteBuilder.new(environment, build_config)
      else
        $logger.warn 'No valid build environment defined!'
        env_builder = PiBuilder.new(environment, skip_build_steps)
      end

      env_builder
    end

  end
end        