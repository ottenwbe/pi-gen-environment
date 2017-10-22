#!/usr/bin/env bash

mkdir -p build

cd pi_build_environment
gem build pi_builder_environment.gemspec
mv *gem ../build/pi_builder_environment.gem
cd ..
cd pi_build_modifier
gem build pi_build_modifier.gemspec
mv *gem ../build/pi_build_modifier.gem
cd ..
cd build
gem install --user-install *

pi_build_modifier version
pi_build_environment version