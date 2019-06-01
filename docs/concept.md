# Concepts
* The pi_customizer defines and orchestrates an __environment__ to run the build of an RasPi image in (e.g., in a VAGRANT box). 
* To store the configuration for the environment and to define a place for the finished image, pi_customizer defines a __local workspace__. 
* Once the environment is up and running, it hosts a __remote workspace__. 
* The __remote workspace__ comprises all files needed to __modify__ and __build__ a RasPi image
    * The workspace is populated by default from a forked git repo of the official raspbian build tool

* __Modification__ steps change files in the remote workspace based on a user defined configuration file
* __Build__ steps are all executed in the environment

# Build Steps

1. Environment creation and selection
1. Environment startup
1. Workspace creation 
1. Load sources to workspace
1. Load modification sources
1. Modify sources in workspace
1. Build pi image
1. Ship pi image to destination
1. Delete Environment

# Modes
1. Prepare and Run - Prepare everything for the environment (e.g., a Vagrantfile) and then simply run the Vagrantfile to build the image
    1. Example: Vagrant
1. Start and Adapt - Start an Environment (e.g., a VM in AWS) and then simply run then configure the environment to build it afterwards
    1. Examples: Docker 