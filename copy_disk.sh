#!/bin/bash

# copy_disk.sh SOURCE_DIR DEST_DIR
#
# DEST_DIR must either be empty or not exist

# Get the $SOURCE_DIR.
SOURCE_DIR=$1
if [ -z $SOURCE_DIR ]; then
    echo "error: you must provide a SOURCE_DIR"
    echo "copy_disk.sh SOURCE_DIR DEST_DIR"
    exit 1
fi

# Test if $SOURCE_DIR exists and is a directory.
if [ ! -d $SOURCE_DIR ]; then
    echo "error: directory $SOURCE_DIR does not exist"
    echo "copy_disk.sh SOURCE_DIR DEST_DIR"
    exit 1
fi

# Get the $DEST_DIR.
DEST_DIR=$2
if [ -z $DEST_DIR ]; then
    echo "error: you must provide a DEST_DIR"
    echo "copy_disk.sh DEST_DIR DEST_DIR"
    exit 1
fi

# If $DEST_DIR does not exist, then create it.
if [ ! -e $DEST_DIR ]; then
    mkdir -p $DEST_DIR
    if [ -e $DEST_DIR ]; then
        echo "created directory $DEST_DIR"
    else
        echo "error: could not create directory $DEST_DIR"
        echo "copy_disk.sh SOURCE_DIR DEST_DIR"
        exit 1
    fi
fi

# Test if $DEST_DIR is empty.
if [ "$(ls -A $DEST_DIR)" ]; then
    echo "error: directory $DEST_DIR is not empty"
    echo "copy_disk.sh SOURCE_DIR DEST_DIR"
    exit 1
fi

# Copy the dir.
shopt -s dotglob
cp -avRf $SOURCE_DIR/* $DEST_DIR

exit 0
