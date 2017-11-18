Potential improvements:

* Add users

* Add ssh-keys (hostkey, user, ...)

* Change hostname

* Add memory cgroup 
    * cgroup_memory=1 in /boot/cmdline.txt before elevator=deadline 

* Disable swapfile 
    * sudo systemctl disable dphys-swapfile

* Install Docker
     * wget -qO- https://get.docker.com/ | sh
        * vs:
     * echo deb https://apt.dockerproject.org/repo debian-stretch main > /etc/apt/sources.list.d/docker.list; apt update
     * apt install docker-ce 
     
* Install Kubernetes
    * curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    * echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
    * apt-get update && apt-get install -y kubeadm                     