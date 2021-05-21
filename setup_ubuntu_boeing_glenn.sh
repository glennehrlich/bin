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

export EMACS=/usr/bin/emacs
rm -rf ~/.emacs.d
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
git clone git@github.com/glennehrlich/notes
git clone git@github.com/glennehrlich/dot-files
git clone git@github.com/glennehrlich/todo
