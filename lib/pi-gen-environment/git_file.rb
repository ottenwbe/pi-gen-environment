require 'fileutils'

class GitFile

  def self.create(gitpath)
    File.open("gitpath", 'w') {|file| file.write(gitpath)}
  end

  def self.rm
    FileUtils.rm "gitpath"
  end
end