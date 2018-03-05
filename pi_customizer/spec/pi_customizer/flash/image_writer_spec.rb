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
require 'pi_customizer/flash/image_writer'
require 'pi_customizer/utils/logex'


describe PiCustomizer::ImageWriter do

  let(:zip_img_file) {File.dirname(__FILE__) + '/../fixtures/image.zip'}
  let(:img_file) {File.dirname(__FILE__) + '/../fixtures/image.img'}

  it 'raises an error when the format is not correct' do
    expect{PiCustomizer::ImageWriter.write('test.txt', '/dev/null')}.to raise_error
  end

  it 'uses dd to write an image to a device' do

  end

  it 'uses dd to write a zipped image to a device' do

  end

end