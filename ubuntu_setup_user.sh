#!/bin/bash

# make_link source destination
function make_link {
    local source=$1
    local destination=$2

    if [ -L $destination ]; then
        rm $destination
        echo "removed symbolic link $destination"
    fi

    if [ -f $destination ]; then
        rm $destination
        echo "removed file $destination"
    fi

    if [ -d $destination ]; then
        echo "error: $destination exists as a directory"
        exit 1
    fi
    
    ln -s $source $destination

    if [ -L $destination ]; then
        echo "created symbolic link $destination to $source"
    else
        echo "error: could not create symbolic link $destination to $source"
        exit 1
    fi
}

make_link /media/psf/Home/r                     ~/r
make_link ~/r/os/linux/home/glenn/.bash_profile ~/.bash_profile
make_link ~/r/os/linux/home/glenn/.bashrc       ~/.bashrc
make_link ~/r/emacs.d                           ~/.emacs.d
make_link /media/psf/Home/.emacs.d.elpa         ~/.emacsd.elpa
make_link /media/psf/Home/.emacs.d.persistent   ~/.emacs.d.persistent
make_link ~/r/git/gitconfig                     ~/.gitconfig
make_link /media/psf/Home                       ~/mac

rm -f ~/.bash_logout ~/.profile
echo "removed useless files"

rm -rf Documents Music Pictures Public Templates Videos
echo "removed useless folders"

exit 0

