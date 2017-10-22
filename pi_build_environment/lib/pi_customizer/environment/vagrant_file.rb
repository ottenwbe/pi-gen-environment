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

require 'erb'
require 'fileutils'

module PiCustomizer
  module Environment
    class VagrantFile

      attr_accessor :vagrant_path, :root, :disk_size

      def initialize
        @vagrant_path = 'envs/vagrant/'
        @disk_size = "'20GB'"
      end

      def render(template)
        ERB.new(template).result(binding)
      end
    end
  end

  class VagrantFileRenderer

    def initialize(vagrant_file)
      @vagrant_file = vagrant_file
    end

    def create_from_template
      check_dependencies
      read_template
      write_rendered
    end

    private def check_dependencies
      unless File.file?(@vagrant_file.vagrant_path.to_s + 'Vagrantfile.erb')
        raise "'Vagrantfile.erb' template not specified. Searching in path '%s'" % [@vagrant_file.vagrant_path]
      end
    end

    private def read_template
      File.open(@vagrant_file.vagrant_path.to_s + 'Vagrantfile.erb', 'r+') do |f|
        @template = f.read
      end
    end

    private def write_rendered
      File.open(@vagrant_file.vagrant_path.to_s + 'Vagrantfile', 'w+') do |f|
        f.write(@vagrant_file.render(@template))
      end
    end

  end
end



