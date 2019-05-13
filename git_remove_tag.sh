#!/bin/bash

# Syntax
# git_remove_tag.sh TAG

# Test if within a git repository.
if ! git rev-parse --is-inside-work-tree  > /dev/null 2>&1; then
    echo "error: not inside a git repository"
    exit 1
fi

# Get the TAG.
TAG=$1
if [[ -z $TAG ]]; then
    echo "error: you must provide a tag"
    exit 1
fi

# Remove the tag locally.
if git tag -d $TAG > /dev/null 2>&1; then
    echo "$TAG removed locally"
else
    echo "error: tag $TAG could not be removed locally"
    exit 1
fi

# Push the deleted tag to the remote.
if git push origin :$TAG > /dev/null 2>&1; then
    echo "$TAG removed from the remote"
else
    echo "error: tag $TAG could not be removed from the remote"
    exit 1
fi

exit 0
