#!/bin/bash

# Can only run in mac.
if [ "$(uname)" != "Darwin" ]; then
    echo "error: must run in Mac OS X"
    exit 1
fi

umount ~/mnt/Shared2
