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

##
# modifiers.rb comprises all classes that orchestrate the build source modifications. One file to avoid the require hell.

require 'json'
require 'erb'
require 'fileutils'
require 'pi_customizer/modify/configs/configs'
require 'pi_customizer/modify/stages/stage'
require 'pi_customizer/utils/logex'
require 'pi_customizer/utils/templates'

module PiCustomizer

  ##
  # Scope for all modifiers of build sources

  module Modifiers

    ##
    # ModifiersBuilder creates a Modifiers object and adds build configuration modifiers which map the (json) config to
    # the the individual pi-gen build sources

    class ModifiersBuilder
      class << self

        ##
        # Initialization and configuration of the modifiers that are used to change and configure the build sources

        def build_defaults(workspace, config)
          modifiers = Modifiers.new
          modifiers.with_json_configuration(config)
          create_modifiers(workspace).each do |*, modifier|
            modifiers.with_config_modifier(modifier)
          end
          modifiers
        end

        private def create_modifiers(workspace)
          {
              :erb_config => create_erb_modifier(workspace),
              :config_file => create_config_file_modifier(workspace),
              :default => create_config_modifier(workspace)
          }
        end

        private def create_config_modifier(workspace)
          config_modifier = ConfigModifier.new(workspace)
          Configs::create_config_modifiers.each do |modifier|
            config_modifier.add(modifier)
          end
          config_modifier
        end

        private def create_erb_modifier(workspace)
          erb_modifier = ERBConfigModifier.new(workspace)
          Configs::create_erb_modifiers.each do |modifier|
            erb_modifier.add(modifier)
          end
          erb_modifier
        end

        private def create_config_file_modifier(workspace)
          config_file_modifier = ConfigFileModifier.new(workspace)
          Configs::create_config_file_modifiers.each do |modifier|
            config_file_modifier.add(modifier)
          end
          config_file_modifier
        end
      end
    end

    ##
    # Modifiers orchestrates all changes specified in the (json) config file.

    class Modifiers

      attr_reader :config_modifiers, :json_data

      def initialize
        @config_modifiers = Array.new
        @json_path = nil
        @json_data = nil
      end

      def with_json_configuration(json_file)
        @json_path = json_file
        self
      end

      def with_config_modifier(config_modifier)
        if config_modifier.is_a? ConfigModifier
          @config_modifiers << config_modifier
        else
          raise 'Parameter must be of type "ConfigModifier"'
        end
        self
      end

      def modify_configs
        load_config
        check_all
        map_all
        verify_all
        modify_all
        finish_all
      end

      private def load_config
        if File.file?(@json_path)
          File.open(@json_path, 'r+') do |f|
            @json_data = JSON.parse(f.read)
          end
        else
          raise "Json configuration file does not exist at '#{@json_path}!'"
        end
      end

      private def verify_all
        @config_modifiers.each(&:verify)
      end

      def check_all
        @config_modifiers.each(&:check)
      end

      private def map_all
        @config_modifiers.each do |mapper|
          mapper.map(@json_data)
        end
      end

      private def modify_all
        @config_modifiers.each(&:modify)
      end

      private def finish_all
        @config_modifiers.each(&:finish)
      end

    end

    ##
    # ConfigModifier (and derived classes) calls the necessary steps to modify pi-gen build sources.
    # It triggers check, mapping, and modification steps for one build configuration change.

    class ConfigModifier

      def initialize(workspace)
        @workspace = workspace
        @configs = Array.new
      end

      def add(config)
        @configs << config
      end

      def check
        $logger.debug("No pre check specified")
      end

      def verify
        @configs.each {|config| config.verify unless config.nil?}
      end

      def map(json_data)
        @configs.each {|config| config.map(json_data) unless config.nil?}
      end

      def modify
        @configs.each {|config| config.modify(@workspace) unless config.nil?}
      end

      def finish
        $logger.debug("Skipped finish")
      end

    end

    ##
    # ConfigFileModifier creates a pi-gen config file

    class ConfigFileModifier < ConfigModifier

      def initialize(workspace)
        super(workspace)
        @cfg_lines = Array.new
        @config_file = 'config'
      end

      def modify
        @configs.each {|config| config.modify(@workspace) if config.class.method_defined? :modify}
        @configs.each {|config| @cfg_lines << config.config_line}
      end

      def finish
        FileUtils.mkdir_p "#{@workspace}"
        File.open(File.join("#{@workspace}", "#{@config_file}"), 'w+') do |file|
          @cfg_lines.each {|cfg_line| file.puts(cfg_line)}
        end
      end

    end

    ##
    # ERBConfigModifier creates configurations from erb templates

    class ERBConfigModifier < ConfigModifier

      def initialize(workspace)
        super(workspace)
      end

      def check
        @configs.each do |config|
          template_path = config.template_path
          output_path = File.join(@workspace, config.relative_output_path)
          template = Templates.read_template(template_path)

          rendered = render(template, config.get_binding)
          original = ""
          File.open(output_path, 'r+') do |f|
            original = f.read
          end

          unless rendered.equal? original
            $logger.warn "Check of sources with default configuration failed:\nrendered = \n\n #{rendered} \n\n != original = \n\n #{original}"
          end

        end
      end

      def modify
        @configs.each do |config|
          if config.can_modify
            template_path = config.template_path
            output_path = File.join(@workspace, config.relative_output_path)

            template = Templates::read_template(template_path)

            # ensure that the output_path is available
            FileUtils.mkdir_p File.dirname output_path

            File.open(output_path, 'w+') do |f|
              f.write(render(template, config.get_binding))
            end

            $logger.info "Created config at #{output_path} from #{template_path}"
          else
            $logger.info "Skipped template #{template_path}"
          end
        end
      end

      private def render(template, binding)
        ERB.new(template).result(binding)
      end

    end

  end
end