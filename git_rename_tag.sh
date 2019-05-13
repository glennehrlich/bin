#!/bin/bash

# Syntax
# git_rename_tag.sh OLD_TAG NEW_TAG

# Test if within a git repository.
if ! git rev-parse --is-inside-work-tree  > /dev/null 2>&1; then
    echo "error: not inside a git repository"
    exit 1
fi

# Get the OLD_TAG.
OLD_TAG=$1
if [[ -z $OLD_TAG ]]; then
    echo "error: you must provide an OLD_TAG"
    echo "syntax: git_rename_tag.sh OLD_TAG NEW_TAG"
    exit 1
fi

# Get the NEW_TAG.
NEW_TAG=$2
if [[ -z $NEW_TAG ]]; then
    echo "error: you must provide a NEW_TAG"
    echo "syntax: git_rename_tag.sh OLD_TAG NEW_TAG"
    exit 1
fi

# Build an alias of the old tag locally.
if git tag $NEW_TAG $OLD_TAG > /dev/null 2>&1; then
    echo "aliased $OLD_TAG to $NEW_TAG locally"
else
    echo "error: could not make alias of $OLD_TAG to $NEW_TAG locally"
    exit 1
fi

# Delete the old tag locally.
if git tag -d $OLD_TAG > /dev/null 2>&1; then
    echo "$OLD_TAG removed locally"
else
    echo "error: $OLD_TAG could not be removed locally"
    exit 1
fi

# Remove the old tag remotely.
if git push origin :refs/tags/$OLD_TAG > /dev/null 2>&1; then
    echo "$OLD_TAG removed from remote"
else
    echo "error: $OLD_TAG could not be removed from remote"
    exit 1
fi

# Push the new tag to the remote.
if git push origin $NEW_TAG > /dev/null 2>&1; then
    echo "$NEW_TAG pushed to remote"
else
    echo "error: $NEW_TAG could not be pushed to remote"
    exit 1
fi

exit 0
