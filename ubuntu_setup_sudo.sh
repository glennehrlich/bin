#!/usr/bin/env bash

# Can only run in linux.
if [ "$(uname)" == "Darwin" ]; then
    echo "error: can not run script in Mac OS X"
    exit 1
fi

# This must be run as sudo.
if [ "$(whoami)" != "root" ]; then
    echo "error: must run with sudo"
    exit 1
fi

# Set up additional apt repos.
add-apt-repository -y ppa:git-core/ppa
add-apt-repository -y ppa:ubuntu-elisp
apt-get update

# Add latest git.
apt-get install -y git

# Add latest emacs.
apt-get install -y emacs-snapshot emacs-snapshot-el

# Add other packages.
apt-get install -y synaptic

exit 0

