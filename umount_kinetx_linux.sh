#!/usr/bin/env bash

# Can only run in linux.
if [ "$(uname)" == "Darwin" ]; then
    echo "error: can not run script in Mac OS X"
    exit 1
fi

umount ~/mnt/Shared2
