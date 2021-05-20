#!/usr/bin/env bash

# ============================================================
# This script must be run as root.
# ============================================================

if [[ "$(whoami)" != "root" ]]; then
    echo "error: must run with root"
    exit 1
fi

# ============================================================
# Install apt-related utilities.
# ============================================================

# Install some apt-related utils.
apt update
apt-get -y install             \
    apt-transport-https        \
    ca-certificates            \
    gnupg                      \
    software-properties-common \
    wget

# ============================================================
# Install git.
# ============================================================

# Add the git ppa.
add-apt-repository ppa:git-core/ppa
apt update

apt-get -y install git

# ============================================================
# Install cmake.
# ============================================================

wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
    gpg --dearmor - | \
    tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null

apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
apt update

apt-get -y install kitware-archive-keyring
rm /etc/apt/trusted.gpg.d/kitware.gpg

apt-get -y install cmake

# ============================================================
# Install vterm.
# ============================================================

apt-get -y install \
    libtool        \
    libtool-bin    \
    pkg-config

cd /tmp
git clone git@github.com:neovim/libvterm.git
cd libvterm
git checkout master
make
make PREFIX=/usr install

# ============================================================
# Install emacs.
# ============================================================

# Get some build tools.
apt-get -y install \
    autoconf       \
    texinfo

# Add the ubuntu emacs snapshot ppa. This is only used to assist
# building emacs. The -s adds the sources repository.
add-apt-repository -s ppa:ubuntu-elisp/ppa
apt update

# Get build dependencies for emacs-snapshot.
apt-get build-dep emacs-snapshot

# Get the emacs git repo.
cd /tmp
git clone --depth 1 https://git.savannah.gnu.org/git/emacs.git

# Build and install.
cd emacs
./autogen.sh
./configure --prefix=/usr/local
make
make install

# ============================================================
# Install ripgrep.
# ============================================================

# Get curl.
apt-get -y install curl

# Get and install.
cd /tmp
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
dpkg -i ripgrep_12.1.1_amd64.deb

# ============================================================
# Install synaptic.
# ============================================================

apt-get -y install synaptic
