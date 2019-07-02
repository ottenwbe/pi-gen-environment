# Concepts
* The pi_customizer defines and orchestrates an __environment__ to run the build of an RasPi image in (e.g., in a VAGRANT box). 
* To store the configuration for the environment and to define a place for the finished image, pi_customizer defines a __local workspace__. 
* Once the environment is up and running, it hosts a __remote workspace__. 
* The __remote workspace__ comprises all files needed to __modify__ and __build__ a RasPi image
    * The workspace is populated by default from a forked git repo of the official raspbian build tool

* __Modification__ steps change files in the remote workspace based on a user defined configuration file
* __Build__ steps are all executed in the environment
