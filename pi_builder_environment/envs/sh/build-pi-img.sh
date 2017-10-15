#!/usr/bin/env bash

# Install dependencies
sudo apt update
sudo apt -y install parted zerofree dosfstools git quilt qemu-user-static debootstrap pxz zip bsdtar ruby-full libcap2-bin

file="gitpath"
if [ -f "$file" ]; then
    git clone "$(< gitpath)"
fi

cd pi-gen
echo "IMG_NAME=\"chiipi\"" > config

wpa_supplicant_folder=stage1/02-net-tweaks/files/interfaces

cp ../conf/wpa_supplicant.json ./stage2/02-net-tweaks/rb

touch ./stage3/SKIP ./stage4/SKIP ./stage5/SKIP
rm stage4/EXPORT* stage5/EXPORT*

# Build it
gem install bundler
gem install rake
gem install rspec

bundle install
rake pi_gen