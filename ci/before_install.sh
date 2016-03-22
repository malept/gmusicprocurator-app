#!/bin/bash

# Install FPM

bundle install

# Build genisoimage

DEB=genisoimage_1.1.11-2ubuntu2_amd64.deb
cd /tmp
wget http://us.archive.ubuntu.com/ubuntu/pool/main/c/cdrkit/$DEB
dpkg-deb --extract $DEB genisoimage

# Build libdmg-hfsplus (dmg)

git clone --single-branch -b amalgamation https://github.com/malept/libdmg-hfsplus
cd libdmg-hfsplus
mkdir build
cd build
cmake ..
make dmg-bin
