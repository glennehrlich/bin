#!/usr/bin/env bash

# The provision directory.
p=/vagrant/provision

# Setup vagrant environment.

# make_link source destination.
function make_link {
    local source=$1
    local destination=$2

    if [[ -L $destination ]]; then
        rm $destination
        echo "removed symbolic link $destination"
    fi

    if [[ -e $destination ]]; then
        rm -rf $destination
        echo "removed file $destination"
    fi

    ln -s $source $destination
    chown -h vagrant:vagrant $destination

    if [[ -L $destination ]]; then
        echo "created symbolic link $destination to $source"
    else
        echo "error: could not create symbolic link $destination to $source"
        exit 1
    fi
}

# This should be run only as root from the vagrant provisioning
# process.
if [[ "$(whoami)" != "root" ]]; then
    echo "error: must run with root from vagrant provisioning"
    exit 1
fi

# Can only run in linux.
if [[ "$(uname)" == "Darwin" ]]; then
    echo "error: can not run script in Mac OS X"
    exit 1
fi

# Check that git exists.
if [[ -e /usr/local/bin/git ]]; then
    GIT=/usr/local/bin/git
elif [[ -e /usr/bin/git ]]; then
    GIT=/usr/bin/git
else
    echo "error: git not present"
    exit 1
fi

# Check that /home/vagrant/host exists.
if [[ ! -e /home/vagrant/host ]]; then
    echo "error: /home/vagrant/host not present"
    exit 1
fi

# Make ~/tmp.
if [[ ! -d /home/vagrant/tmp ]]; then
    mkdir /home/vagrant/tmp
    chown vagrant:vagrant /home/vagrant/tmp
    echo "created /home/vagrant/tmp directory"
fi

# ============================================================
# Install libvterm
echo "Starting installation of libvterm"

# Install cmake.
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y cmake3
ln -s /usr/bin/cmake3 /usr/bin/cmake

# Make libvterm.
mkdir -p /tmp/vterm
cd /tmp/vterm
VTERM=libvterm-0.1.3
VTERM_TAR=${VTERM}.tar.gz
if ! curl --fail --silent --show-error --location https://launchpad.net/libvterm/trunk/v0.1/+download/${VTERM_TAR} --output ${VTERM_TAR}; then
    echo "error: could not download $VTERM_TAR; skipping installation of libvterm"
else
    echo "Downloaded $VTERM_TAR"
    tar xzf $VTERM_TAR
    cd $VTERM
    make all install
    echo "Finished installing libvterm"
fi
# ============================================================

# Build our own emacs.
/home/vagrant/bin/provision_emacs_redhat.sh

# Save the original .bashrc
mv /home/vagrant/.bashrc /home/vagrant/.bashrc.original
chown vagrant:vagrant /home/vagrant/.bashrc.original

# Link all of the directories and dot files.
make_link /home/vagrant/dot-files/bams/.bash_profile        /home/vagrant/.bash_profile
make_link /home/vagrant/dot-files/bams/.bashrc              /home/vagrant/.bashrc
make_link /home/vagrant/dot-files/ubuntu-vagrant/.gitconfig /home/vagrant/.gitconfig

# Set up emacs
( cd /home/vagrant ;          su vagrant -c "$GIT clone https://github.com/glennehrlich/emacs.d .emacs.d" )
( cd /home/vagrant ;          su vagrant -c "mkdir .emacs.d.elpa" )
( cd /home/vagrant/.emacs.d ; su vagrant -c "EMACS=/usr/local/bin/emacs make create_persistent_dirs" )
( cd /home/vagrant/.emacs.d ; su vagrant -c "EMACS=/usr/local/bin/emacs make update_elpa" )
( cd /home/vagrant/.emacs.d ; su vagrant -c "EMACS=/usr/local/bin/emacs make -k clean all" ) # make -k because vterm will not build in redhat
rm -rf /home/vagrant/.emacs.d.persistent.old

# Get adobe source code pro fonts.
$GIT clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git /home/vagrant/.fonts/adobe-fonts/source-code-pro
fc-cache -f -v /home/vagrant/.fonts/adobe-fonts/source-code-pro
chown -R vagrant:vagrant /home/vagrant/.fonts
echo "added adobe source code pro font"

# Remove useless files.
rm -f /home/vagrant/.bash_logout /home/vagrant/.profile
echo "removed useless files"

# Remove useless folders.
rm -rf Documents Music Pictures Public Templates Videos
echo "removed useless folders"

exit 0
