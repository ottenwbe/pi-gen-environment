require 'pi-gen-environment/git_file'
require 'fileutils'
require 'pathname'

RSpec.describe GitFile do

  let(:git_path) {'test'}

  it 'allows to create and remove a "gitpath" file' do
    GitFile.create("#{git_path}")
    expect(Pathname.new('gitpath')).to be_file
    GitFile.rm
    expect(Pathname.new('gitpath')).to_not be_file
  end
end