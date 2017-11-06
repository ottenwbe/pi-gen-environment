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
require 'pi_customizer/environment/vagrant/vagrant_file'
require 'fileutils'
require 'pathname'

module PiCustomizer
  module Environment
    RSpec.describe VagrantFileRenderer do

      let(:vagrant_file) {VagrantFile.new('', nil)}
      let(:vagrant_file_builder) {VagrantFileRenderer.new(vagrant_file)}

      it 'renders a valid file' do

        vagrant_file_builder.create_from_template

        expect(Pathname.new(File.join(File.dirname(__FILE__), '/../../../envs/vagrant/Vagrantfile'))).to be_file
      end

      it 'checks if the Vagrantfile.erb exists' do
        vagrant_file.vagrant_path = 'some/random/path'

        expect{vagrant_file_builder.create_from_template}.to raise_error("'Vagrantfile.erb' template not specified. Searching in path 'some/random/path'")
      end

    end
  end
end