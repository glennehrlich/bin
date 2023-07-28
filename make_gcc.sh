#!/usr/bin/env bash

RELEASE=12.2
VERSION=$RELEASE.0

rm -rf ~/tmp/objdir
mkdir -p ~/tmp/objdir
 
cd ~/tmp
 
# You will want to be off of the Boeing vpn when doing this step or download it on windows and transfer it into your vm.
curl -OL https://ftp.gnu.org/gnu/gcc/gcc-$VERSION/gcc-$VERSION.tar.gz
 
tar xzvf gcc-$VERSION.tar.gz
 
cd gcc-$VERSION
./contrib/download_prerequisites
 
cd ~/tmp/objdir

# Do the configure step, if you get an error from the configure step, see the next 2 lines for a modified configure step.
# If you're running an ubuntu variant, you will almost certainly get an error and have to do the alternate configure step.
# ../gcc-$VERSION/configure --prefix=/opt/gcc-$RELEASE --enable-languages=c,c++
# or 
# Use this step if using an Ubuntu variant
# Alternate configure step:
../gcc-$VERSION/configure --prefix=/opt/gcc-$RELEASE --enable-languages=c,c++ --disable-multilib
 
# This step will take a couple hours
make -j `nproc`
 
sudo make install
