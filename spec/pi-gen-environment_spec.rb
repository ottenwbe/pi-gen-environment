require 'pi-gen-environment'
require 'fileutils'
require 'pi-gen-environment/logex'

RSpec.describe PiGen do
  context 'ECHO' do
    it 'starts a build when the command line parameter \'build\' is passed' do
      expect(STDOUT).to receive(:puts).with('Echo: - Git Path:  and Workspace Path: ')
      PiGen.start(%w(build ECHO))
    end

    it 'reads the git_path variable' do
      expect(STDOUT).to receive(:puts).with('Echo: - Git Path: git and Workspace Path: ')
      PiGen.start(%w(build ECHO --git_path=git))
    end

  end
end