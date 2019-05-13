#!/bin/bash

# Syntax
# git_remove_branch.sh BRANCH

# Test if within a git repository.
if ! git rev-parse --is-inside-work-tree  > /dev/null 2>&1; then
    echo "error: not inside a git repository"
    exit 1
fi

# Get the BRANCH.
BRANCH=$1
if [[ -z $BRANCH ]]; then
    echo "error: you must provide a branch"
    exit 1
fi

# Remove the branch locally.
if git branch -d $BRANCH > /dev/null 2>&1; then
    echo "$BRANCH removed locally"
else
    echo "error: branch $BRANCH could not be removed locally"
    exit 1
fi

# Push the deleted branch to the remote.
if git push origin :$BRANCH > /dev/null 2>&1; then
    echo "$BRANCH removed from the remote"
else
    echo "error: branch $BRANCH could not be removed from the remote"
    exit 1
fi

exit 0
