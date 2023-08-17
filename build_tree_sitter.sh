#!/usr/bin/env bash

# This install the latest tree-sitter library and headers into
# /usr/local.

# This must be run as sudo.
if [ "$(whoami)" != "root" ]; then
    echo "error: must run with sudo"
    exit 1
fi

# Obtain and build tree-sitter.
cd /tmp
git clone https://github.com/tree-sitter/tree-sitter.git
cd tree-sitter
make -j `nproc`
make install
