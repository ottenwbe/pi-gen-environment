require 'thor'
require 'fileutils'
require_relative 'pi-gen-environment/vagrant'
require_relative 'pi-gen-environment/aws'
require_relative 'pi-gen-environment/workspace'

class PiGen < Thor

  desc 'build ENV', 'Build pi image on environment ENV (options are AWS or VAGRANT).'
  option :git_path
  option :workspace

  def build(env)
    workspace = Workspace.new(workspace_dir: options[:workspace], git_location: options[:git_path])
    workspace.run do
      case env
        when 'AWS'
          AWS.new.build
        when 'VAGRANT'
          Vagrant.new.build
        when 'ECHO'
          puts "Git Path: #{options[:git_path]}"
        else
          puts 'NO valid build environment (AWS or VAGRANT) defined!'
      end
    end
  end
end
