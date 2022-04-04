#!/usr/bin/env bash

# ============================================================
# Usage:
#
# This script must be run while off of the Boeing Enterprise Network
# (aka GlobalProtect) because it will download software from the
# internet.
#
# This script must be run as root, not as sudo:
#   sudo passwd root
#   <change root password to whatever, suggestion: "root">
#
# To run:
#   cd /tmp
#   wget https://raw.githubusercontent.com/glennehrlich/bin/master/setup_ubuntu_boeing_root.sh
#   chmod +x setup_ubuntu_boeing_root.sh
#   su -
#     <enter root password>
#   ./setup_ubuntu_boeing_root.sh
# ============================================================

function banner {
    local msg=$1

    echo
    echo "============================================================"
    echo $msg
    echo "============================================================"
    echo
}

# ============================================================
# Check that we are running as root.
# ============================================================

if [[ "$(whoami)" != "root" ]]; then
    echo "error: must run with root"
    exit 1
fi

# ============================================================
banner "Install utilities"
# ============================================================

# Install some needed utils.
apt update
apt-get -y install             \
    apt-transport-https        \
    ca-certificates            \
    curl                       \
    gnupg                      \
    software-properties-common \
    synaptic                   \
    wget

# ============================================================
banner "Install git"
# ============================================================

# Add the git ppa.
add-apt-repository -y ppa:git-core/ppa
apt update

apt-get -y install git

# ============================================================
banner "Install gcc / g++ 11"
# ============================================================

# Add the toolchain ppa.
add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt update

apt-get -y install gcc-11 g++-11

# ============================================================
banner "Install cmake"
# ============================================================

# wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
#     gpg --dearmor - | \
#     tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null

# apt-add-repository -y 'deb https://apt.kitware.com/ubuntu/ impish main'
# apt update

# apt-get -y install kitware-archive-keyring
# rm /etc/apt/trusted.gpg.d/kitware.gpg

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
apt-get -y build-dep emacs-snapshot

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

# Get and install.
cd /tmp
rm -f ripgrep*
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
dpkg -i ripgrep*_amd64.deb

# ============================================================
banner "Install pandoc"
# ============================================================

cd /tmp
rm -f pandoc*
curl -LO https://github.com/jgm/pandoc/releases/download/2.16.2/pandoc-2.16.2-1-amd64.deb
dpkg -i pandoc*.deb

# ============================================================
banner "Install plantuml"
# ============================================================

cd /tmp
rm -f plantuml*
curl -LO https://github.com/plantuml/plantuml/releases/download/v1.2022.1/plantuml-1.2022.1.jar
cp plantuml*.jar /usr/local/bin
cd /usr/local/bin
ln -s plantuml-1.2022.1.jar plantuml.jar

# ============================================================
banner "Install Ubuntu MATE color themes"
# ============================================================

add-apt-repository -y ppa:lah7/ubuntu-mate-colours
apt-get -y install ubuntu-mate-colours-all

# ============================================================
banner "Removing unattended-upgrades"
# ============================================================

apt-get -y --purge autoremove unattended-upgrades

# ============================================================
banner "Install openjdk 8"
# ============================================================

apt-get -y install openjdk-11-jdk

# ============================================================
banner "Install maven"
# ============================================================

apt-get -y install maven

# # ============================================================
# banner "Make /opt/data/logs directory"
# # ============================================================

# mkdir -p /opt/data/logs
# chmod -R go+rw /opt/data

# ============================================================
banner "BC2 stuff"
# ============================================================

# apt-get update
# apt-get -y install meld
# apt-get -y install openssl
# apt-get -y install libssl-dev
# apt-get -y install doxygen
# apt-get -y install python2
# apt-get -y install python3
# apt-get -y install ruby
# apt-get -y install cyrus-sasl-devel
# apt-get -y install uuid-dev
# apt-get -y install alien dpkg-dev debhelper build-essential
# apt-get -y install pip
# apt-get -y install python3-pip
# apt-get -y install docker.io
# pip install --user conan
# pip3 install --user docker-compose
# pip3 install websockets

apt-get update

apt-get -y install \
        docker.io  \
        doxygen    \
        graphviz   \
        rpm


