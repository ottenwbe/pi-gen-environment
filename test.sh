#!/usr/bin/env bash

cd pi_customizer
bundle install
bundle exec rake
cd ../pi_build_modifier
bundle install
bundle exec rake
