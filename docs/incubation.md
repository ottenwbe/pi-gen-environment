Potential improvements:


* Add users

* Add ssh-keys (hostkey, user, ...)

* Change hostname

* Disable swapfile 
    * sudo systemctl disable dphys-swapfile

* Install Docker
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
     
* Install Kubernetes
    * curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    * echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
    * apt-get update && apt-get install -y kubelet kubeadm kubectl
    
    
    
                       