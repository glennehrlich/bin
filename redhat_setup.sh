#!/bin/bash

# Setup redhat environment.

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
    chown -h glenn:glenn $destination

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
    echo "error: must run as root"
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

# Check that /home/glenn/r exists.
if [ ! -e /home/glenn/r ]; then
    echo "error: /home/glenn/r not present"
    exit 1
fi

# Make ~/tmp.
if [ ! -d /home/glenn/tmp ]; then
    mkdir /home/glenn/tmp
    chown glenn:glenn /home/glenn/tmp
    echo "created /home/glenn/tmp directory"
fi

# Save the original .bashrc files.
mv /home/glenn/.bashrc /home/glenn/.bashrc.original
chown glenn:glenn /home/glenn/.bashrc.original
mv /home/glenn/.bashrc_profile /home/glenn/.bashrc_profile.original
chown glenn:glenn /home/glenn/.bashrc_profile.original

# Link all of the directories and dot files.
make_link /home/glenn/host/.emacs.d.elpa                       /home/glenn/.emacs.d.elpa
make_link /home/glenn/host/r/os/linux/home/glenn/.bash_profile /home/glenn/.bash_profile
make_link /home/glenn/r/emacs.d                                /home/glenn/.emacs.d
make_link /home/glenn/r/git/gitconfig                          /home/glenn/.gitconfig
make_link /home/glenn/r/os/vagrant/k/.bashrc                   /home/glenn/.bashrc

# Create the emacs persistent directories.
( cd /home/glenn/.emacs.d ; su glenn -c "make create_persistent_dirs" )
chown -R glenn:glenn /home/glenn/.emacs.d.persistent
rm -rf /home/glenn/.emacs.d.persistent.old

# Get adobe source code pro fonts.
git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git /home/glenn/.fonts/adobe-fonts/source-code-pro
fc-cache -f -v /home/glenn/.fonts/adobe-fonts/source-code-pro
chown -R glenn:glenn /home/glenn/.fonts
echo "added adobe source code pro font"

# Remove useless files.
rm -f /home/glenn/.bash_logout /home/glenn/.profile
echo "removed useless files"

# Remove useless folders.
rm -rf Documents Music Pictures Public Templates Videos
echo "removed useless folders"

exit 0

