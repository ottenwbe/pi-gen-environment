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

require_relative '../../spec_helper'
require 'fileutils'
require 'pathname'
require 'pi_customizer/build/workspace/remote_workspace'


RSpec.describe PiCustomizer::Workspace::RemoteWorkspace do

  let(:git_path) {'../pi-gen-test'}
  let(:default_git) {'https://github.com/ottenwbe/pi_customizer.git'}

  it 'allows us to check for parameter equality' do
    remote_workspace_1 = PiCustomizer::Workspace::RemoteWorkspace.new('a', 'b', 'd')
    remote_workspace_2 = PiCustomizer::Workspace::RemoteWorkspace.new('a', 'b', 'd')
    expect(remote_workspace_1==remote_workspace_2).to be true
  end

  it 'allows us to check for parameter inequality' do
    remote_workspace_1 = PiCustomizer::Workspace::RemoteWorkspace.new('a', 'b')
    remote_workspace_2 = PiCustomizer::Workspace::RemoteWorkspace.new('c', 'd')
    expect(remote_workspace_1==remote_workspace_2).to be false
  end

  it 'initializes with known default values' do
    remote_workspace = PiCustomizer::Workspace::RemoteWorkspace.new()
    expect(remote_workspace.workspace_directory).to eq PiCustomizer::Workspace::DEFAULT_REMOTE_WORKSPACE_DIRECTORY            
    expect(remote_workspace.git_path).to eq PiCustomizer::Workspace::DEFAULT_GIT_PATH
    expect(remote_workspace.git_tag).to eq PiCustomizer::Workspace::DEFAULT_GIT_TAG
  end

end