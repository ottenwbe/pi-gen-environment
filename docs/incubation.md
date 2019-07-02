* As a builder of a pi image I want to add ssh-keys and bake them into the image (hostkey, admin users public key, ...) to avoid adding it afterwards manually
* As a builder of a pi image I want to be able to disable the swap file for my image, e.g., to be able to install kubernetes on it
    * sudo systemctl disable dphys-swapfile
* As a maintainer of the pi image build sources fork I want to be informed if the templates used for the pi_build_modifier are out of date, to avoid inconsistencies
* As a builder of a pi image I want to change the hostname of the pi image
* As a build of a pi image I want to install custom software
* As a build of a pi image I want to install Docker
     * echo deb https://apt.dockerproject.org/repo debian-stretch main > /etc/apt/sources.list.d/docker.list; apt update
     * apt install docker-ce 
     * ------------ or:
     apt-get update
     apt-get install \
          apt-transport-https \
          ca-certificates \
          curl \
          gnupg2 \
          software-properties-common
     curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
     echo "deb [arch=armhf] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
        $(lsb_release -cs) stable" | \
        tee /etc/apt/sources.list.d/docker.list

     apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.09 | head -1 | awk '{print $3}')
    
    
    
                       