# pi-customizer

[![Build Status](https://travis-ci.org/ottenwbe/pi-gen-environment.svg?branch=master)](https://travis-ci.org/ottenwbe/pi-gen-environment)

|Gem                |Badge      |
|:-:|:-:|
| pi_customizer     | [![Gem Version](https://badge.fury.io/rb/pi_customizer.svg)](https://badge.fury.io/rb/pi_customizer)  | 
| pi_build_modifier | [![Gem Version](https://badge.fury.io/rb/pi_build_modifier.svg)](https://badge.fury.io/rb/pi_build_modifier)  | 


The _pi_customizer_ allows you to adapt Raspbian images to your needs.
To this end, the Raspbian image is be built from [scratch](https://github.com/ottenwbe/pi-gen.git) 
with all customizations baked in.

The core of the project is a set of Ruby gems which adapt the [pi-gen](https://github.com/RPi-Distro/pi-gen) build scripts.

# WIP Notice

This project is still under construction and in a pre release phase.

# Install

## Prerequisites

To customize the build process the following prerequisites are expected:
* The _pi_customizer_ gem is installed (see the [__Deploy Gem__](#deploy_gem) section for details) 
* One of the supported build environments is accessible (see the [__Environments__](#environments) section):  
    * Vagrant 
    * Docker (feature is still in development)    
    * AWS (feature is still in development)

<a name="deploy_gem"></a>
## Deploy Gem

To customize your Raspbian image the pi_customizer gem must be installed on the machine that coordinates the build process.
This is typically your local machine.

1. Install the latest (pre) release. For all prerequisites see the corresponding section. 

    ```bash
    gem install pi_customizer --pre
    ```
    
1. Verify the installation
    
    ```bash
    pi_customizer version
    ```
<a name="environments"></a>
## Environments

You may choose to build your pi image in a Vagrant box.
In the future AWS ec2 and Docker container will also be supported.

### Vagrant

1. Install Vagrant. For instance, on Fedora:

    ```bash
    sudo dnf install vagrant
    ```

1. Verify that vagrant is installed
    
    ```
    vagrant -v
    ```        

1. Install the `vagrant-disksize` plugin
    
    ```
    vagrant plugin install vagrant-disksize
    ```        

### Docker

Note: feature still in development

Docker uses a temporary folder as volume to build the image. 
The folder location can be changed with the build option __tmp-folder__, which is set to "${PWD}/tmp" by default.

Note: the type of the tmp directory needs to be changed on SELinux

    chcon -Rt svirt_sandbox_file_t "${PWD}/tmp"
    
After the image is built, undo the changes.    
    
    restorecon -v "${PWD}/tmp"

### AWS

Note: feature still in development

# Usage

To build a default image in a Vagrant box, simply execute on the command line

    pi_customizer build VAGRANT


To customize your build:
1. Any customizations have to be specified in a json configuration file (see the [__Config File__](#config_file) section for details).
1. The build process itself is then configured with command line options (see `pi_customizer help build` for details)   
     

<a name="config_file"></a>
## Config File

An example of the json config file with all current configuration options

    {
      "system": {
        "name" : "custompi",
        "type" : "lite"
      },
      "ssh" : {
        "enabled" : true
      },
      "locale": {
        "gen" : ["en_GB.UTF-8 UTF-8", "de_DE.UTF-8 UTF-8"],
        "sys" : "en_GB.UTF-8"
      },
      "wifi": {
        "networks": [
          {
            "ssid": "your_secret_ssid",
            "wpsk": "your_secret_psk"
          }
        ],
        "wpa_country": "DE"
      }
    }

### The system section

* To choose a custom name for your pi image, specify the __name__ value. The default is _custompi_.

* To build a lite version of the pi image, specify the __type__ as lite, otherwise specify it as full. The default is _full_.

### The ssh section

* To disable ssh by default, set __enabled__ to false.

### The locale section

* Select one or more locales to be generated: e.g., "en_GB.UTF-8 UTF-8", "de_DE.UTF-8 UTF-8", ...
* Select the default locale, typically en_GB.UTF-8, which is the default.

### The wifi section

* The wifi section allows you to specify networks and passkeys as well as the wpa_country.

# Development

### Prerequisites

Make sure Ruby is installed (and dependencies to build native extensions)

On Fedora:


    sudo dnf group install "C Development Tools and Libraries"
    sudo dnf install ruby ruby-devel     
    sudo dnf install redhat-rpm-config 
    
## Test

RSpec tests can be executed for all modules by calling the following rake command in the project root.

    rake spec
    
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ottenwbe/pi-gen-environment. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
    
## License

The gems are available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
    