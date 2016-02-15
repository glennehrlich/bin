#!/bin/bash

# Mount the boeing drives.

# net use h: \\134.51.42.21\um268c          !a31962Doctor /USER:sw\um268c /PERSISTENT:NO
mount -t smbfs //um268c:\!a31962Doctor@134.51.42.21/um268c h
echo "h drive mounted"

# net use o: \\134.51.42.21\Organizations   !a31962Doctor /USER:sw\um268c /PERSISTENT:NO
mount -t smbfs //um268c:\!a31962Doctor@134.51.42.21/Organizations o
echo "o drive mounted"

