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

require 'erb'
require 'json'

module PiBuildModifier

  ##
  # The Locale class is used to customize locales

  class Boot

    C_GROUPS = 'cgroups'

    C_GROUP_MEMORY = 'memory'

    attr_accessor :c_groups

    attr_reader :template_path, :relative_output_path

    def initialize(c_groups = [''])
      @c_groups = c_groups
      @template_path = File.join(File.dirname(__FILE__), '/templates/07-resize-init.diff.erb').to_s
      @relative_output_path = 'stage2/01-sys-tweaks/00-patches/07-resize-init.diff'
    end

    def mapper(workspace)
      ERBMapper.new(self,workspace)
    end

    def map(json_data)
      unless json_data.nil? || !json_data.has_key?(C_GROUPS)
        if json_data[C_GROUPS].has_key?(C_GROUP_MEMORY) && json_data[C_GROUPS][C_GROUP_MEMORY]
          @c_groups << 'cgroup_enable=memory cgroup_memory=1 swapaccount=1'
        end
      end
    end

    def get_binding
      binding
    end

  end

end

