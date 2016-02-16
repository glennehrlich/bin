#!/bin/bash

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

    if [ -L $destination ]; then
        echo "created symbolic link $destination to $source"
    else
        echo "error: could not create symbolic link $destination to $source"
        exit 1
    fi
}

# Can only run in linux.
if [ "$(uname)" == "Darwin" ]; then
    echo "error: can not run script in Mac OS X"
    exit 1
fi

# Check that git exists.
if [ ! -e /usr/bin/git ]; then
    echo "error: git not present, run ubuntu_setup_sudo.sh first"
    exit 1
fi

# Make ~/tmp.
if [ ! -d ~/tmp ]; then
    mkdir ~/tmp
    echo "created ~/tmp directory"
fi

# Link all of the directories and dot files.
make_link /media/psf/Home/r                     ~/r
make_link ~/r/os/linux/home/glenn/.bash_profile ~/.bash_profile
make_link ~/r/os/linux/home/glenn/.bashrc       ~/.bashrc
make_link ~/r/emacs.d                           ~/.emacs.d
make_link /media/psf/Home/.emacs.d.elpa         ~/.emacs.d.elpa
make_link /media/psf/Home/.emacs.d.persistent   ~/.emacs.d.persistent
make_link ~/r/git/gitconfig                     ~/.gitconfig
make_link /media/psf/Home                       ~/mac

# Get adobe source code pro fonts.
git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git ~/.fonts/adobe-fonts/source-code-pro
fc-cache -f -v ~/.fonts/adobe-fonts/source-code-pro
echo "added adobe source code pro font"

# Remove useless files.
rm -f ~/.bash_logout ~/.profile
echo "removed useless files"

# Remove useless folders.
rm -rf Documents Music Pictures Public Templates Videos
echo "removed useless folders"

echo
echo "you must restart linux for fonts to take effect"

exit 0

