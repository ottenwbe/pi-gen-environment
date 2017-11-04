# pi-customizer

[![Build Status](https://travis-ci.org/ottenwbe/pi-gen-environment.svg?branch=master)](https://travis-ci.org/ottenwbe/pi-gen-environment)

A set of (Ruby) scripts to customize Raspbian images.
The Rapbian image is built using a [fork](https://github.com/ottenwbe/pi-gen.git) of the [official build tool](https://github.com/RPi-Distro/pi-gen).

##WIP Notice

This project is still under construction...


# Usage

To customize the build process the following things are needed:
* The 'pi_customizer' Gem is installed
* A config file which describes the customizations
* You have access to one of the supported build environments: 
    * Docker
    * Vagrant (feature is still in development)
    * AWS (feature is still in development)

### Deploy Gem

1. Download the latest release: 

    ```bash
    __TODO__
    ```
    
1. Install the Gem. For all prerequisites see the corresponding section.
    
    ```bash
    gem install pi_customizer-<version>.gem
    ```

## Config file

An example of the json config file with all current configuration options

    {
      "system": {
        "name" : "chiipi",
        "type" : "lite"
      },
      "ssh" : {
        "enabled" : true
      },
      "wifi": {
        "networks": [
          {
            "ssid": "your ssid",
            "wpsk": "your psk"
          }
        ],
        "wpa_country": "DE"
      }
    }

### The system section

* To choose a custom name for your pi image, specify the __name__ value. The default is _chiipi_.

* To build a lite only version of the pi image, specify the __type__ as lite, otherwise specify it as full. The default is _lite_.

### The ssh section

* To disable ssh by default, set __enabled__ to false.

### The wifi section

* The Wifi section allows you to specify networks and passkeys as well as the wpa_country.

## Environments

You may choose to build your pi image in a Docker container.
In the future on AWS ec2 instances and Vagrant Boxes will also be supported.

### Docker

Docker uses a temporary folder as volume to build the image. 
The folder location can be changed with the build option __tmp-folder__, which is set to "${PWD}/tmp" by default.

Note: the type of the tmp directory needs to be changed on SELinux

    chcon -Rt svirt_sandbox_file_t "${PWD}/tmp"
    
Afterwards change the type back.    
    
    restorecon -v "${PWD}/tmp"

### Vagrant

Note: feature still in development

### AWS

Note: feature still in development

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
    