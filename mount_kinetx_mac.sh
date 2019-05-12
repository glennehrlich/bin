#!/usr/bin/env bash

# Can only run in mac.
if [ "$(uname)" != "Darwin" ]; then
    echo "error: must run in Mac OS X"
    exit 1
fi

mkdir -p ~/mnt/Shared2

mount -t smbfs //KINETX\;glenn.ehrlich:\!Doctor1962@devfap01.ad.kinetx.com/Shared2 ~/mnt/Shared2
