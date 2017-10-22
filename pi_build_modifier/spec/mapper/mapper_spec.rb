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

require 'rspec'
require_relative '../../lib/pi_build_modifier/mapper/mapper'
require 'FileUtils'

module PiBuildModifier
  RSpec.describe Mapper do

    let(:test_text) {'Test Text'}
    let(:json_path) {'test.json'}
    let(:template_path) {'template.erb'}
    let(:output_path) {File.dirname(__FILE__) + '/' + 'output.conf'}
    let(:output_file_name) {'output.conf'}


    before(:each) do
      File.open(json_path, 'w') {|file| file.write('{"test":"%s"}' % [test_text])}
      File.open(template_path, 'w') {|file| file.write('<%= @test %>')}
    end

    after(:each) do
      FileUtils.rm(json_path)
      FileUtils.rm(template_path)
      FileUtils.rm(output_path)
    end


    it 'should map a json description and an erb template to a config' do

      #Given
      mapper = Mapper.new(TestMapper.new(template_path, output_file_name), json_path, File.dirname(__FILE__))

      #When
      mapper.do_map

      #Then
      expect(Pathname.new(output_path)).to be_file
      expect(IO.binread(Pathname.new(output_path))).to eq test_text
    end
  end

  class TestMapper

    attr_accessor :test
    attr_reader :template_path, :relative_output_path

    def initialize(template_path, relative_output_path)
      @template_path = template_path
      @relative_output_path = relative_output_path
    end

    def map(data)
      @test = data['test']
    end

    def get_binding
      binding
    end
  end

end
