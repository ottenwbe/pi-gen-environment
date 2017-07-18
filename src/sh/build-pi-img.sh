#!/usr/bin/env bash

# Install dependencies
sudo apt update
sudo apt -y install quilt qemu-user-static debootstrap pxz zip bsdtar

# Get build sources
git clone quilt qemu-user-static debootstrap pxz zip bsdtar

cd pi-gen
echo "IMG_NAME=\"chiipi\"" > config

# Build it
sudo ./build.sh
