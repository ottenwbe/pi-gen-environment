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
require 'rspec'
require 'fileutils'
require 'json'
require 'pi_build_modifier/modifier/erb_mapper'
require 'pi_build_modifier/modifier/mapper'

module PiBuildModifier

  RSpec.describe Mapper do
    it 'should implement a method modify' do
      expect(Mapper.new(nil)).to respond_to(:modify)
    end
    it 'should implement a method map' do
      expect(Mapper.new(nil)).to respond_to(:map)
    end
  end

  RSpec.describe ERBMapper do

    let(:test_text) {'Test Text'}
    let(:json_path) {'test.json'}
    let(:template_path) {'template.erb'}
    let(:output_path) {File.dirname(__FILE__) + '/' + 'output.config'}
    let(:output_file_name) {'output.config'}

    @json_data = nil

    before do
      File.open(json_path, 'w') {|file| file.write('{"test":"%s"}' % [test_text])}
      File.open(json_path, 'r+') {|f| @json_data = JSON.parse(f.read)}
      File.open(template_path, 'w') {|file| file.write('<%= @test %>')}
    end

    after do
      FileUtils.rm(json_path)
      FileUtils.rm(template_path)
    end

    it 'should implement a Mapper' do
      expect(ERBMapper.new(TestData.new(template_path, output_file_name), '')).to be_a Mapper
    end

    it 'should raise an error when created with invalid data (i.e., the mapped data is nil)' do
      expect {ERBMapper.new(nil, '')}.to raise_error
    end

    it 'should map a json configuration and an erb template to a config file' do

      #Given
      mapper = ERBMapper.new(TestData.new(template_path, output_file_name), File.dirname(__FILE__))

      #When
      mapper.map(@json_data)
      mapper.modify

      #Then
      expect(Pathname.new(output_path)).to be_file
      expect(IO.binread(Pathname.new(output_path))).to eq test_text

      #Clean up
      FileUtils.rm(output_path)
    end
  end

  class TestData

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
