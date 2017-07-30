# pi-gen-environment

##WIP Notice

This project is still under construction...

## Start and build the environment
 
 1. Create a folder _src/ssh_ and generate a ssh key pair, e.g.,    
        
        ssh-keygen -t rsa -C "deployer" -P '' -f src/ssh/pi-builder -b 4096
        
2. Execute the terraform script
        
        terraform apply
        
3. Log-in to the environment and check if the img is built

        ssh ubuntu@<pi-builder-ip>
        
4. Fetch the img in pi-gen/deploy via scp     

    vagrant scp vagrant@default:~/pi-gen/deploy/image_2017-07-28-chiipi-lite.zip

         
Install it on the card:
    