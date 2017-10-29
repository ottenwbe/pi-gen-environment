#!/usr/bin/env bash

set +e

pushd .
mkdir -p build

pushd .
echo "Create gem pi_customizer"
cd pi_customizer
gem build pi_customizer.gemspec
mv *gem ../build/pi_customizer.gem
popd

pushd .
echo "Create gem pi_build_modifier"
cd pi_build_modifier
gem build pi_build_modifier.gemspec
mv *gem ../build/pi_build_modifier.gem
popd

pushd .
echo "Install gems"
cd build
gem install --user-install pi_build_modifier.gem
gem install --user-install pi_customizer.gem
popd

echo "Validate installation"

pi_build_modifier version

pi_customizer version

pi_customizer build ECHO

pi_customizer build VAGRANT

popd

wait