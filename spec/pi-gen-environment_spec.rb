require 'pi-gen-environment'
require 'fileutils'

RSpec.describe PiGen do
  context 'ECHO' do
    it 'starts a build when the command line parameter \'build\' is passed' do
      expect(STDOUT).to receive(:puts).with('Git Path: ')
      PiGen.start(["build", "ECHO"])
    end

    it 'reads the git_path variable' do
      expect(STDOUT).to receive(:puts).with('Git Path: git')
      PiGen.start(["build", "ECHO", "--git_path=git"])
    end

  end
end