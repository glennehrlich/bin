#!/bin/bash

# clonevm.sh ORIGINAL_VM NEW_VM
#
# Clone ORIGINAL_VM giving it the name NEW_VM. If NEW_VM exists, it is
# deleted first.

# Get the $ORIGINAL_VM.
ORIGINAL_VM=$1
if [ -z "$ORIGINAL_VM" ]; then
    echo "error: you must provide ORIGINAL_VM"
    echo "clonevm.sh ORIGINAL_VM NEW_VM"
    exit 1
fi

# Get the NEW_VM.
NEW_VM=$2
if [ -z "$NEW_VM" ]; then
    echo "error: you must provide NEW_VM"
    echo "clonevm.sh NEW_VM NEW_VM"
    exit 1
fi

# Test if ORIGINAL_VM exists.
if ! VBoxManage showvminfo "$NEW_VM" > /dev/null 2>&1; then
    echo "error: original vm \"$ORIGINAL_VM\" does not exist"
    echo "clonevm.sh ORIGINAL_VM NEW_VM"
    exit 1
fi

# If NEW_VM exists, then delete it.
if VBoxManage showvminfo "$NEW_VM" > /dev/null 2>&1; then
    echo "vm \"$NEW_VM\" exists, deleting it first"

    # Poweroff the vm.
    VBoxManage controlvm "$NEW_VM" poweroff > /dev/null 2>&1

    # Delete the vm.
    if ! VBoxManage unregistervm "$NEW_VM" --delete > /dev/null 2>&1; then
        echo "error: could not delete vm \"$NEW_VM\""
        exit 1
    else
        echo "vm \"$NEW_VM\" deleted"
    fi
fi

# Clone the vm.
if ! VBoxManage clonevm "$ORIGINAL_VM" --name "$NEW_VM" --register > /dev/null 2>&1; then
    echo "error: could not clone vm \"$ORIGINAL_VM\""
    exit 1
else
    echo "vm \"$ORIGINAL_VM\" cloned to \"$NEW_VM\""
    exit 0
fi
