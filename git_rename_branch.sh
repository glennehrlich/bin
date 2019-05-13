#!/bin/bash

# Syntax
# git_rename_branch.sh OLD_BRANCH NEW_BRANCH

# Test if within a git repository.
if ! git rev-parse --is-inside-work-tree  > /dev/null 2>&1; then
    echo "error: not inside a git repository"
    exit 1
fi

# Get the OLD_BRANCH.
OLD_BRANCH=$1
if [[ -z $OLD_BRANCH ]]; then
    echo "error: you must provide an OLD_BRANCH"
    echo "syntax: git_rename_branch.sh OLD_BRANCH NEW_BRANCH"
    exit 1
fi

# Get the NEW_BRANCH.
NEW_BRANCH=$2
if [[ -z $NEW_BRANCH ]]; then
    echo "error: you must provide a NEW_BRANCH"
    echo "syntax: git_rename_branch.sh OLD_BRANCH NEW_BRANCH"
    exit 1
fi

# Rename the old branch locally.
if git branch -m $OLD_BRANCH $NEW_BRANCH > /dev/null 2>&1; then
    echo "$OLD_BRANCH renamed locally"
else
    echo "error: branch $OLD_BRANCH could not be renamed locally"
    exit 1
fi

# Push the old branch to the remote.
if git push origin :$OLD_BRANCH > /dev/null 2>&1; then
    echo "$OLD_BRANCH renamed on the remote"
else
    echo "error: branch $OLD_BRANCH could not be renamed on the remote"
    exit 1
fi

# Push the new branch, set the local branch to track the new remote.
# git defect: git is returning non-zero exit even when successful here, so no test for success.
git push --set-upstream origin $NEW_BRANCH

exit 0
