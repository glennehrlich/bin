#!/bin/bash

# The provision directory.
p=/vagrant/.provision

# Do not do normal error handling as this script will be eventually
# run from within user_customization_redhat.sh and scripts invoked
# from that should not run in error handling context.
# Setup error checking.
# source $p/error_handling.sh $0

FILE=glenn_emacs.tgz
PROVISION_DIR=/home/vagrant/p/.provision
TAR_FILE=$PROVISION_DIR/$FILE

# Build emacs from source.

# Get the dependencies for building emacs. Unfortunately a lot of
# these dependencies are required in make install.
yum install -y \
GConf2-devel \
dbus-devel \
dbus-glib-devel \
dbus-python \
giflib-devel \
gnutls \
gnutls-devel \
gpm-devel \
gtk3-devel \
libXft-devel \
libXpm-devel \
libjpeg-devel \
libpng-devel \
libtiff-devel \
ncurses-devel \
pkgconfig

# Install the cached version if it exists.
if [ -e $TAR_FILE ]; then
    cd /tmp
    tar xzf $TAR_FILE
    cd emacs
    make install
    exit 0
fi

# Clone the emacs repo.
cd /tmp
git clone --depth 1 https://git.savannah.gnu.org/git/emacs.git
cd emacs

./autogen.sh
./configure --without-makeinfo --with-gif=no --with-modules
make
make install

# Cache it.
cd /tmp
tar czf $TAR_FILE emacs

exit 0
