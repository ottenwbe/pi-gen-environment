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

require 'pi_build_modifier/modify/modifier/modifiers'
require 'pi_build_modifier/modify/modifier/erb_config_modifier'
require 'pi_build_modifier/modify/modifier/config_file_modifier'
require 'pi_build_modifier/modify/configs/configs'

module PiBuildModifier
  module Cmd

    ##
    # Modifier triggers all changes specified in the config. To this end,
    # it configures and calls specialized mappers which map the config to
    # the the individual pi-gen build scripts.

    class Modifier

      attr_reader :modifiers

      ##
      # Initialization and configuration of the modifiers that are used to change in the pi-gen build sources

      def initialize(config, workspace, modifiers = Modifiers.new)
        @modifiers = configure_modifiers(modifiers, workspace, config)
      end

      private def configure_modifiers(modifiers, workspace, config)
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

      def create_config_modifier(workspace)
        config_modifier = ConfigModifier.new(workspace)
        create_config_modifiers.each do |modifier|
          config_modifier.add(modifier)
        end
        config_modifier
      end

      private def create_erb_modifier(workspace)
        erb_modifier = ERBMapper.new(workspace)
        create_erb_modifiers.each do |modifier|
          erb_modifier.add(modifier)
        end
        erb_modifier
      end

      private def create_config_file_modifier(workspace)
        config_file_modifier = ConfigFileModifier.new(workspace)
        create_config_file_modifiers.each do |modifier|
          config_file_modifier.add(modifier)
        end
        config_file_modifier
      end

      private def create_config_modifiers
        [TypeConfig.new]
      end

      private def create_erb_modifiers
        []
      end

      private def create_config_file_modifiers
        [NameConfig.new, SshConfig.new]
      end

      def execute
        @modifiers.modify
      end

    end
  end
end