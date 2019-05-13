#!/bin/bash

# Syntax
# git_changed_files.sh BRANCH1 BRANCH2
#
# Example
# git_changed_files.sh dev_branch master

# Get BRANCH1.
BRANCH1=$1
if [[ -z $BRANCH1 ]]; then
    echo "error: not enough command line arguments"
    echo "syntax:"
    echo "git_changed_files.sh BRANCH1 BRANCH2"
    exit 1
fi

# Get BRANCH2.
BRANCH2=$2
if [[ -z $BRANCH2 ]]; then
    echo "error: not enough command line arguments"
    echo "syntax:"
    echo "git_changed_files.sh BRANCH1 BRANCH2"
    exit 1
fi

git --no-pager diff --name-only $BRANCH1 $(git merge-base $BRANCH1 $BRANCH2)
