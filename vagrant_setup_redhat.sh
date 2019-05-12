#!/usr/bin/env bash

# Setup vagrant environment.

# make_link source destination.
function make_link {
    local source=$1
    local destination=$2

    if [ -L $destination ]; then
        rm $destination
        echo "removed symbolic link $destination"
    fi

    if [ -e $destination ]; then
        rm -rf $destination
        echo "removed file $destination"
    fi

    ln -s $source $destination
    chown -h vagrant:vagrant $destination

    if [ -L $destination ]; then
        echo "created symbolic link $destination to $source"
    else
        echo "error: could not create symbolic link $destination to $source"
        exit 1
    fi
}

# This should be run only as root from the vagrant provisioning
# process.
if [ "$(whoami)" != "root" ]; then
    echo "error: must run with root from vagrant provisioning"
    exit 1
fi

# Can only run in linux.
if [ "$(uname)" == "Darwin" ]; then
    echo "error: can not run script in Mac OS X"
    exit 1
fi

# Check that git exists.
if [ ! -e /usr/bin/git ]; then
    echo "error: git not present"
    exit 1
fi

# Check that /home/vagrant/host exists.
if [ ! -e /home/vagrant/host ]; then
    echo "error: /home/vagrant/host not present"
    exit 1
fi

# Check that /home/vagrant/r exists.
if [ ! -e /home/vagrant/r ]; then
    echo "error: /home/vagrant/r not present"
    exit 1
fi

# Make ~/tmp.
if [ ! -d /home/vagrant/tmp ]; then
    mkdir /home/vagrant/tmp
    chown vagrant:vagrant /home/vagrant/tmp
    echo "created /home/vagrant/tmp directory"
fi

# Save the original .bashrc
mv /home/vagrant/.bashrc /home/vagrant/.bashrc.original
chown vagrant:vagrant /home/vagrant/.bashrc.original

# Link all of the directories and dot files.
make_link /home/vagrant/host/.emacs.d.elpa                       /home/vagrant/.emacs.d.elpa
make_link /home/vagrant/host/r/os/linux/home/glenn/.bash_profile /home/vagrant/.bash_profile
make_link /home/vagrant/r/emacs.d                                /home/vagrant/.emacs.d
make_link /home/vagrant/r/git/gitconfig                          /home/vagrant/.gitconfig
make_link /home/vagrant/r/os/vagrant/bams/.bashrc                /home/vagrant/.bashrc

# Create the emacs persistent directories.
( cd /home/vagrant/.emacs.d ; su vagrant -c "make create_persistent_dirs" )
chown -R vagrant:vagrant /home/vagrant/.emacs.d.persistent
rm -rf /home/vagrant/.emacs.d.persistent.old

# Get adobe source code pro fonts.
# git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git /home/vagrant/.fonts/adobe-fonts/source-code-pro
git clone --depth 1 --branch release git@github.com:adobe-fonts/source-code-pro.git /home/vagrant/.fonts/adobe-fonts/source-code-pro
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

