#!/bin/bash

# This needs to be run as the user.

# Link up to ~/r
ln -s /mnt/hgfs/r ~/r

# Link up the dot files.
~/r/bin/link_dot_files.sh

# Remove the useless folders.
rm -rf Documents Music Pictures Public Templates Videos

