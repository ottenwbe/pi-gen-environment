require 'pi_build_environment/environment/aws'
require 'fileutils'
require 'pathname'

module PiCustomizer
  module Environment
    RSpec.describe AWS do

      let(:key_name) {'pi-test'}

      it 'creates an ssh key' do
        AWS.new.create_keys(key_name)
        expect(Pathname.new("ssh/#{key_name}.pem")).to be_file
        expect(Pathname.new("ssh/#{key_name}.pub")).to be_file
      end

      it 'deletes an existing ssh key' do
        aws = AWS.new
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