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

mkdir -p /home/glenn/mnt
chown glenn:glenn /home/glenn/mnt

mkdir -p /home/glenn/mnt/Shared2
chown glenn:glenn /home/glenn/mnt/Shared2

mount -t cifs //devfap01.ad.kinetx.com/Shared2 ~/mnt/Shared2 -o user=glenn.ehrlich,domain=KINETX,password=\!Doctor1962,uid=1000,gid=1000
