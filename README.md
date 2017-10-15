# pi-gen-environment


[![Build Status](https://travis-ci.org/ottenwbe/pi-gen-environment.svg?branch=master)](https://travis-ci.org/ottenwbe/pi-gen-environment)

## WIP Notice

This project is still under construction...


## What is pi-gen-environment?

'Pi-gen-environment' is able to configure and personalize 
you presonal raspbian image.

## Dpendencies

- vagrant or terraform (+aws account)
- ruby
- rake

## Development 

Current development is done on the development branch.

## Start and build the environment

1. Create your customized json files in the conf folder

1. Run rake, which starts a vagrant box to build your personalized raspbian image.

        rake

