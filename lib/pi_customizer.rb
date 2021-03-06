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

require 'thor'
require 'fileutils'
require 'pi_customizer/version'
require 'pi_customizer/build/builder/builder'
require 'pi_customizer/build/config/remote_workspace'
require 'pi_customizer/build/config/local_workspace'
require 'pi_customizer/build/config/build_config'
require 'pi_customizer/build/environment/environment_factory'
require 'pi_customizer/modify/modifiers'
require 'pi_customizer/trigger/build'
require 'pi_customizer/write/image_writer'
require 'pi_customizer/utils/logex'

module PiCustomizer

  ##
  # PiCustomizer defines all of pi_customizer's cli commands

  class PiCustomizer < Thor

    ##
    # The build command can be called by a user to trigger a customized build of a pi image

    desc 'build [ENV]', 'Build pi image on environment ENV (valid environments are: VAGRANT, LOCAL)'
    method_option :config_file, :aliases => '-c', :required => true, :desc => 'Path to the configuration file.'
    method_option :build_sources_git_url, :default => Workspace::DEFAULT_GIT_PATH, :aliases => '-g'
    method_option :build_sources_git_tag, :default => Workspace::DEFAULT_GIT_TAG, :aliases => '-t'
    method_option :remote_workspace_dir, :default => Workspace::DEFAULT_REMOTE_WORKSPACE_DIRECTORY, :aliases => '-w'
    method_option :local_workspace_dir, :default => Workspace::DEFAULT_LOCAL_WORKSPACE_DIRECTORY, :aliases => '-l'
    method_option :modifier_gem, :default => '', :aliases => '-m', :desc => 'Path to the modifier_gem. If not specified, the most recent gem from rubygems.org is downloaded.'
    method_option :deploy_dir, :default => Dir.getwd, :aliases => '-d'
    method_option :skip_steps, :type => :array, :aliases => '-s'

    def build(env)
      begin
        remote_workspace = Workspace::RemoteWorkspace.new("#{options[:remote_workspace_dir]}", "#{options[:build_sources_git_url]}", "#{options[:build_sources_git_tag]}")
        local_workspace = Workspace::LocalWorkspaceConfig.new("#{options[:config_file]}", "#{options[:local_workspace_dir]}", "#{options[:modifier_gem]}")
        build_config = Config::BuildConfig.new(options[:skip_steps])

        environment = Environment::environment_factory(env, local_workspace, remote_workspace)
        builder = Builder::PiBuilder.new(environment, build_config)

        builder.build
      rescue Exception => e
        $logger.error "Fatal build error: #{e.message}"
      end
    end

    ##
    # The trigger command triggers the pi image's build scripts

    desc 'trigger WORKSPACE PUBLISH_FOLDER', 'Build the pi image in WORKSPACE and publish it to PUBLISH_FOLDER'

    def trigger(workspace, publish_folder)
      Trigger::build(workspace)
      Trigger::publish(workspace, publish_folder)
    end


    ##
    # The modify command allows users to modify pi-gen sources in a given workspace based on a given configuration

    desc 'modify CONFIG WORKSPACE', 'Modify the pi image sources at the specified WORKSPACE with the specified configuration file CONFIG.'

    def modify(config, workspace)
      $logger.debug "Modifying with a configuration read from '#{config}' in the workspace '#{workspace}'"
      Modifiers::ModifiersBuilder::build_defaults(workspace, config).modify_configs
    end

    ##
    # The version command allows users to query for the current version of the pi_customizer gem. It is printed on the command line.

    desc 'v, version', 'Shows the version number.'

    def version
      puts VERSION
    end

    ##
    # Allow users to write an image to a device, i.e., a SD card

    desc 'write IMAGE DEVICE', 'Write an image to a device.'

    def write_image(image, device)
      begin
        ImageWriter.new.write(image, device)
      rescue Exception => e
        $logger.error e.message
      end
    end

  end
end