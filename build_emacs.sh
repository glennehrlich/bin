#!/usr/bin/env bash

# You must run build_tree_sitter.sh before running this script to
# build and install the latest version of tree-sitter (which installs
# into /usr/local).

# This must be run as sudo.
if [ "$(whoami)" != "root" ]; then
    echo "error: must run with sudo"
    exit 1
fi

# Get some build tools.
apt-get -y install autoconf texinfo

# Add the ubuntu emacs snapshot ppa. This is only used to assist
# building emacs. The -s adds the sources repository.
add-apt-repository -y -s ppa:ubuntu-elisp/ppa

# Add the ubuntu tool chain ppa so that libgccjit can be obtained.
add-apt-repository -y ppa:ubuntu-toolchain-r/ppa

apt-get update

# Get build dependencies for emacs-snapshot. Need gcc10 in order to do
# native elisp compilation.
apt-get -y install gcc-10 g++-10 libgccjit0 libgccjit-10-dev libjansson4 libjansson-dev gnutls-bin
apt-get -y build-dep emacs-snapshot

# Get the emacs git repo.
cd /tmp
rm -rf emacs
git clone --depth 1 https://git.savannah.gnu.org/git/emacs.git

# Need these to be set for the native compilation.
export CC=/usr/bin/gcc-10
export CXX=/usr/bin/g++-10

# Build and install.

cd emacs
./autogen.sh
./configure --prefix=/usr/local --without-compress-install --with-native-compilation=aot --with-tree-sitter --with-json --with-mailutils
make NATIVE_FULL_AOT=1 -j `nproc`

echo "test out emacs and then install with sudo make install"
