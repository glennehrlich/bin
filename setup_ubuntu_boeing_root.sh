#!/usr/bin/env bash

function banner {
    local msg=$1

    echo "============================================================"
    echo $msg
    echo "============================================================"
    echo ""
}

# ============================================================
# This script must be run as root.
# ============================================================

if [[ "$(whoami)" != "root" ]]; then
    echo "error: must run with root"
    exit 1
fi

# ============================================================
banner "Install apt-related utilities"
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
banner "Install git"
# ============================================================

# Add the git ppa.
add-apt-repository -y ppa:git-core/ppa
apt update

apt-get -y install git

# ============================================================
banner "Install cmake"
# ============================================================

wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
    gpg --dearmor - | \
    tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null

apt-add-repository -y 'deb https://apt.kitware.com/ubuntu/ bionic main'
apt update

apt-get -y install kitware-archive-keyring
rm /etc/apt/trusted.gpg.d/kitware.gpg

apt-get -y install cmake

# ============================================================
banner "Install vterm"
# ============================================================

apt-get -y install \
    libtool        \
    libtool-bin    \
    pkg-config

cd /tmp
git clone https://github.com/neovim/libvterm.git

cd libvterm
git checkout master
make
make PREFIX=/usr install

# ============================================================
banner "Install emacs"
# ============================================================

# Get some build tools.
apt-get -y install \
    autoconf       \
    texinfo

# Add the ubuntu emacs snapshot ppa. This is only used to assist
# building emacs. The -s adds the sources repository.
add-apt-repository -y -s ppa:ubuntu-elisp/ppa
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
banner "Install ripgrep"
# ============================================================

# Get curl.
apt-get -y install curl

# Get and install.
cd /tmp
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
dpkg -i ripgrep_12.1.1_amd64.deb

# ============================================================
banner "Install synaptic"
# ============================================================

apt-get -y install synaptic
