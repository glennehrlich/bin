#!/usr/bin/env bash

# sudo make_sbcl.sh <version>
# sudo make_sbcl.sh sbcl-1.1.3
# sudo make_sbcl.sh master

VERSION=$1
# export SBCL_ARCH=x86-64 # no longer needed as of sbcl-1.0.58

echo "updating git"
cd /usr/local/sbcl
git pull origin master
echo " "

echo "building for the first time"
rm -rf *
git checkout $VERSION
git reset --hard
# rm -rf customize-target-features.lisp
# ln -s ~/r/lisp/sbcl/customize-target-features.lisp customize-target-features.lisp
# sh make.sh --with-sb-thread
sh make.sh --fancy
INSTALL_ROOT=/usr/local sh install.sh
echo " "

# Docs only built 2nd time

echo "rebuilding again"
rm -rf *
git checkout $VERSION
git reset --hard
# rm -rf customize-target-features.lisp
# ln -s ~/r/lisp/sbcl/customize-target-features.lisp customize-target-features.lisp
# sh make.sh --with-sb-thread
sh make.sh --fancy
cd doc/manual
make
cd /usr/local/sbcl
INSTALL_ROOT=/usr/local sh install.sh
