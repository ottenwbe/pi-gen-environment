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

require_relative '../../spec_helper'
require 'rspec'
require 'pi_customizer/build/environment/environment'
require 'pi_customizer/utils/logex'

RSpec.describe PiCustomizer::Environment::EnvironmentControl do

  let(:environment) {PiCustomizer::Environment::EnvironmentControl.new(nil,nil)}


  it 'warns about skipped check steps' do
    expect($logger).to receive(:warn).with(/skipped/)
    environment.check
  end

  it 'warns about skipped prepare steps' do
    expect($logger).to receive(:warn).with(/skipped/)
    environment.prepare
  end

  it 'warns about skipped start steps' do
    expect($logger).to receive(:warn).with(/skipped/)
    environment.start
  end

  it 'warns about skipped build steps' do
    expect($logger).to receive(:warn).with(/skipped/)
    environment.build_image
  end

  it 'warns about skipped publish steps' do
    expect($logger).to receive(:warn).with(/skipped/)
    environment.publish
  end

  it 'warns about skipped publish steps' do
    expect($logger).to receive(:warn).with(/skipped/)
    environment.publish
  end

  it 'warns about skipped clean_up steps' do
    expect($logger).to receive(:warn).with(/skipped/)
    environment.clean_up
  end

  it 'warns about skipped stop steps' do
    expect($logger).to receive(:warn).with(/skipped/)
    environment.stop
  end

  it 'informs about skipped ensure steps' do
    expect($logger).to receive(:info).with(/skipped/)
    environment.ensure
  end
end
