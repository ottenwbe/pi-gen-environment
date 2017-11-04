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

require_relative '../../spec_helper'
require 'fileutils'
require 'pathname'
require 'pi_customizer/workspace/workspace'

module PiCustomizer
  module Workspace
    RSpec.describe Workspace do

      let(:git_path) {'../pi-gen-test'}
      let(:default_git) {'https://github.com/ottenwbe/pi_customizer.git'}

      #it 'allows to create and remove a workspace and destroys it afterwards' do
      #  git_file = Workspace.new(git_path, default_git)
      #  git_file.do_work do
      #    expect(Pathname.new("#{git_path}")).to be_directory
      #  end
      #end
    end
  end
end