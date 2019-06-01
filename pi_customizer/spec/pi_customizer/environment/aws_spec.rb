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
require 'pi_customizer/build/environment/aws/aws'
require 'fileutils'
require 'pathname'

module PiCustomizer
  module Environment
    RSpec.describe AWS do

      let(:key_name) {'pi-test'}

      it 'creates an ssh key' do
        AWS.new(nil, '').create_keys(key_name)
        expect(Pathname.new("ssh/#{key_name}.pem")).to be_file
        expect(Pathname.new("ssh/#{key_name}.pub")).to be_file
      end

      it 'deletes an existing ssh key' do
        aws = AWS.new(nil, '')
        aws.create_keys(key_name)
        aws.del_keys(key_name)

        expect(Pathname.new("ssh/#{key_name}.pem")).to_not be_file
        expect(Pathname.new("ssh/#{key_name}.pub")).to_not be_file
      end

      after(:each) do
        if File.file?("ssh/#{key_name}.pub")
          FileUtils.rm "ssh/#{key_name}.pem"
        end
        if File.file?("ssh/#{key_name}.pub")
          FileUtils.rm "ssh/#{key_name}.pub"
        end
      end
    end
  end
end