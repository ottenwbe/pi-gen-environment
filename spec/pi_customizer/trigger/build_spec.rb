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
require 'pi_customizer/trigger/build'


RSpec.describe PiCustomizer::Trigger do

  let(:workspace) {File.join(File.dirname(__FILE__), '/workspace_build')}
  let(:mock_build_sh) {File.join(File.dirname(__FILE__), '/workspace_build/build.sh')}
  let(:expected_done_file) {File.join(File.dirname(__FILE__), '/workspace_build/done')}

  before(:each) do
    FileUtils.mkdir_p workspace
    File.open(mock_build_sh, 'w') {|file| file.write("#!/bin/bash\ntouch #{expected_done_file}")}
    File.chmod(0777, "#{mock_build_sh}")
  end

  after(:each) do
    FileUtils.rm_rf workspace
  end

  it 'executes the build script' do
    PiCustomizer::Trigger.build(workspace)
    expect(Pathname.new(expected_done_file)).to be_file
  end
end
