#!/usr/bin/env bash

# ============================================================
# Usage:
#
# This script must be run while off of the Boeing Enterprise Network
# (aka GlobalProtect) because it will download software from the
# internet.
#
# This script must be run as glenn, not as sudo.
#
# To run:
#   cd /tmp
#   wget https://raw.githubusercontent.com/glennehrlich/bin/master/setup_ubuntu_boeing_glenn.sh
#   chmod +x setup_ubuntu_boeing_glenn.sh
#   ./setup_ubuntu_boeing_glenn.sh
# ============================================================

function banner {
    local msg=$1

    echo
    echo "============================================================"
    echo $msg
    echo "============================================================"
    echo
}

function make_link {
    local source=$1
    local destination=$2

    if [[ -L $destination ]]; then
        rm $destination
        # echo "removed symbolic link $destination"
    fi

    if [[ -e $destination ]]; then
        rm -rf $destination
        # echo "removed file $destination"
    fi

    ln -s $source $destination

    if [[ -L $destination ]]; then
        echo "created symbolic link $destination to $source"
    else
        echo "error: could not create symbolic link $destination to $source"
        exit 1
    fi
}

# ============================================================
# Check that we are running as user glenn.
# ============================================================

if [[ "$(whoami)" != "glenn" ]]; then
    echo "error: must run as user glenn"
    exit 1
fi

# ============================================================
banner "Making ~/tmp"
# ============================================================

mkdir ~/tmp

# ============================================================
banner "Install personal emacs configuration"
# ============================================================

rm -rf ~/.emacs.d
rm -rf ~/.emacs.d.elpa
git clone git@github.com:glennehrlich/emacs.d ~/.emacs.d
mkdir ~/.emacs.d.elpa
cd ~/.emacs.d
make create_persistent_dirs
make update_elpa
make clean all

# ============================================================
banner "Clone personal directories"
# ============================================================

cd
git clone git@github.com:glennehrlich/bin
git clone git@github.com:glennehrlich/dot-files
git clone git@github.com:glennehrlich/notes
git clone git@github.com:glennehrlich/todo

# ============================================================
banner "Set up dot files"
# ============================================================

make_link ~/dot-files/boeing/.gitconfig ~/.gitconfig

mkdir ~/.m2
make_link ~/dot-files/boeing/.m2/settings.xml ~/.m2/settings.xml

make_link ~/dot-files/boeing/.bashrc       ~/.bashrc
make_link ~/dot-files/boeing/.bash_profile ~/.bash_profile

# ============================================================
banner "Removing bash history"
# ============================================================

history -c
