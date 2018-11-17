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

require 'fileutils'
require 'pi_build_modifier/modifier/mapper'


module PiBuildModifier

  ##
  # RunModifier is a class which appends lines to the sys-tweaks run file in the pi-gen build directory.
  # By default this is the file 'stage2/01-sys-tweaks/01-run.sh'.

  class RunModifier < Mapper

    attr_reader :relative_output_path, :appender

    def initialize
      @appender = Array.new
      @workspace = nil
      @relative_output_path = 'stage2/01-sys-tweaks/01-run.sh'
    end

    def mapper(workspace)
      @workspace = workspace
      self
    end

    def append(appender)
      @appender << appender
    end

    ##
    # modify the sys-tweaks run file by adding lines at the end of the file

    def modify
      open("#{@workspace}/#{@relative_output_path}", 'a') do |f|
        f.puts ''
        @appender.each do |a|
          f.puts "source #{@workspace}/#{a.append_line}"
        end
      end
    end

  end
end