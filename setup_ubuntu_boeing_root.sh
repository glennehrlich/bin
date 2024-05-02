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
# Software versions
# ============================================================

GCC_VERSION_DEB=11
GCC_VERSION=11.2

RIPGREP_VERSION=13.0.0
PANDOC_VERSION=2.16.2
PLANTUML_VERSION=1.2022.5
GLOBAL_VERSION=6.6.8
JAVA_VERSION=11

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
banner "Install gcc / g++ ${GCC_VERSION_DEB}"
# ============================================================

# Add the toolchain ppa.
# add-apt-repository -y ppa:ubuntu-toolchain-r/test
# apt update

apt-get -y install gcc-${GCC_VERSION_DEB} g++-${GCC_VERSION_DEB}

gcc-${GCC_VERSION_DEB} --version

cd /opt

mkdir gcc-${GCC_VERSION}
cd gcc-${GCC_VERSION}

mkdir bin
cd bin

ln -s /usr/bin/cpp-${GCC_VERSION_DEB}        cpp
ln -s /usr/bin/c++-${GCC_VERSION_DEB}        c++
ln -s /usr/bin/gcc-${GCC_VERSION_DEB}        gcc
ln -s /usr/bin/gcc-ar-${GCC_VERSION_DEB}     gcc-ar
ln -s /usr/bin/gcc-nm-${GCC_VERSION_DEB}     gcc-nm
ln -s /usr/bin/gcc-ranlib-${GCC_VERSION_DEB} gcc-ranlib
ln -s /usr/bin/gcov-${GCC_VERSION_DEB}       gcov
ln -s /usr/bin/gcov-dump-${GCC_VERSION_DEB}  gcov-dump
ln -s /usr/bin/gcov-tool-${GCC_VERSION_DEB}  gcov-tool
ln -s /usr/bin/g++-${GCC_VERSION_DEB}        g++
ln -s /usr/bin/lto-dump-${GCC_VERSION_DEB}   lto-dump

cd /opt/gcc-${GCC_VERSION}
ln -s /usr/lib/gcc/x86_64-linux-gnu/${GCC_VERSION} lib64

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

echo
echo "install warnings are ok"

# ============================================================
banner "Install emacs"
# ============================================================

# Get some build tools.
apt-get -y install autoconf texinfo

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
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}_amd64.deb
dpkg -i ripgrep*_amd64.deb

# ============================================================
banner "Install pandoc"
# ============================================================

cd /tmp
rm -f pandoc*
curl -LO https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-amd64.deb
dpkg -i pandoc*.deb

# ============================================================
banner "Install plantuml"
# ============================================================

cd /tmp
rm -f plantuml*
curl -LO https://github.com/plantuml/plantuml/releases/download/v${PLANTUML_VERSION}/plantuml-${PLANTUML_VERSION}.jar
rm -f /usr/local/bin/plantuml*
cp plantuml*.jar /usr/local/bin
cd /usr/local/bin
ln -s plantuml-${PLANTUML_VERSION}.jar plantuml.jar

# ============================================================
banner "Install gnu global"
# ============================================================

cd /tmp
rm -f global*
curl -LO https://ftp.gnu.org/pub/gnu/global/global-${GLOBAL_VERSION}.tar.gz
tar xzf global*.tar.gz
cd global*/
./configure
make
make install

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
banner "Install openjdk ${JAVA_VERSION}"
# ============================================================

apt-get -y install openjdk-${JAVA_VERSION}-jdk

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

apt-get -y install  \
        docker.io   \
        doxygen     \
        graphviz    \
        jsonnet     \
        python2     \
        python3-pip \
        rpm         \
        ruby

adduser glenn vboxsf

