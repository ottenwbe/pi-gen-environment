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

require 'fileutils'
require 'erb'
require 'pi_build_modifier/utils/templates'

module PiBuildModifier
  module Stages
    class Stage

      attr_accessor :packages, :folder_name

      def initialize(packages)
        @folder_name = 'stage06'
        @packages = Packages.new(packages)
        @workspace = '.'
        @full_stage_folder = ''
      end

      def create_in(workspace)
        @full_stage_folder = create_folder(workspace)
        create_prerun
        create_packages
      end

      private def create_folder(workspace)
        full_stage_folder = File.join(workspace, @folder_name)
        FileUtils.mkdir_p(full_stage_folder)
        full_stage_folder
      end

      private def create_prerun
        FileUtils.cp(File.join(File.dirname(__FILE__), '/files/prerun.sh'), @full_stage_folder)
        FileUtils.chmod("ugo=rx", File.join(@full_stage_folder, 'prerun.sh'))
      end

      private def create_packages
        package_folder_name = File.join(@full_stage_folder, '00-install-packages')
        package_file_name = File.join(package_folder_name, '00-packages')

        template = Templates::read_template(File.join(File.dirname(__FILE__), '/templates/packages.erb'))
        rendered = ERB.new(template, nil, '-').result(@packages.get_binding)

        FileUtils.mkdir_p package_folder_name
        File.open(package_file_name, 'w+') do |file|
          file.puts rendered
        end
      end

    end

    class Packages

      attr_accessor :packages

      def initialize(packages)
        @packages = packages.nil? ? Array.new : packages
      end

      def get_binding
        binding
      end

    end

  end
end