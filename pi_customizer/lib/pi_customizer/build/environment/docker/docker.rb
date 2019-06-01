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

require 'pi_customizer/utils/logex'

module PiCustomizer
  module Environment
    class Docker < EnvironmentControl

      DOCKERFILE_PATH = File.join(File.dirname(__FILE__), '/../../../../envs/docker')
      DOCKERFILE = "#{DOCKERFILE_PATH}/Dockerfile"
      CONFIG_PATH_IN_DOCKER = '/resources'

      def check

        puts 'NOTE: Docker is not yet officially supported!'

        $logger.info '[Check | Docker] Pre-flight checks are executing...'
        ensure_docker
      end

      def start
        $logger.info "[Start | Docker] Build docker image: #{DOCKERFILE}"
        system "docker build --rm=true --file=#{DOCKERFILE} --tag=pi:build #{DOCKERFILE_PATH}"
        $logger.info "[Start | Docker] Start docker image with volume #{@config.tmp_directory}:#{@workspace.workspace_directory}"
        system "sudo docker run -v #{@config.tmp_directory}:#{@workspace.workspace_directory}:rw -v /dev:/dev -v /lib/modules:/lib/modules --cap-add=ALL --privileged=true --detach  --security-opt label:disable pi:build \"/sbin/init\" > cid"
      end

      def prepare
        prepare_workspace
        prepare_configuration
      end

      def build_image
        $logger.info '[Build| Docker] customization of build sources'
        system "sudo docker exec --tty \"$(cat cid)\" bash -c \"sudo pi_build_modifier modify #{CONFIG_PATH_IN_DOCKER}/resources.json #{@workspace.workspace_directory}\""
        $logger.info '[Build| Docker] pi-image build step'
        system "sudo docker exec --tty \"$(cat cid)\" bash -c \"cd #{@workspace.workspace_directory} && sudo ./build.sh\"" #sudo chown docker #{@workspace.workspace_directory} &&
      end

      def clean_up
        $logger.info '[Clean Up | Docker] pi-image remove contents of temporary container'
      end

      def stop
        $logger.info '[Stop | Docker] Stop pi:build container'
        #system 'docker stop "$(cat cid)"'
        $logger.info '[Stop | Docker] RM pi:build container'
        #system 'docker rm "$(cat cid)"'
        #TODO: rm cid file!
      end

      private def ensure_docker
        unless system 'docker -v'
          raise 'Docker is not installed. Please ensure that Docker is running.'
        end
      end

      private def prepare_configuration
        $logger.info "[Prepare | Docker] Copy the configuration file from #{@config.config_path} to #{CONFIG_PATH_IN_DOCKER}/resources.json in container"
        system "docker exec --tty \"$(cat cid)\" bash -c \"sudo mkdir -p #{CONFIG_PATH_IN_DOCKER}\""
        system "docker cp #{@config.config_path} \"$(cat cid)\":#{CONFIG_PATH_IN_DOCKER}/resources.json"
        gem_path = File.join(File.dirname(__FILE__), '/../../../../envs/pi_build_modifier.gem')
        system "docker cp #{gem_path} \"$(cat cid)\":#{CONFIG_PATH_IN_DOCKER}/pi_build_modifier.gem"
        system "docker exec --tty \"$(cat cid)\" bash -c \"sudo gem install #{CONFIG_PATH_IN_DOCKER}/pi_build_modifier.gem\""
      end

      private def prepare_workspace
        $logger.info "[Prepare | Docker] Clone git project: #{@workspace}"
        system "docker exec --tty \"$(cat cid)\" bash -c \"sudo mkdir -p #{@workspace.workspace_directory}\""
        #TODO: git clone vs git pull when code exists...
        system "docker exec --tty \"$(cat cid)\" bash -c \"sudo git clone #{@workspace.git_path} #{@workspace.workspace_directory}\""
      end

    end
  end
end
