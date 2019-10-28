#!/bin/bash

# Run the vm command bin/deploy.sh in the current git repository.

# Test if within a git repository.
if ! git rev-parse --is-inside-work-tree  > /dev/null 2>&1; then
    echo "error: not inside a git repository"
    exit 1
fi

# cd to the toplevel of the git repository.
git_repo=`git rev-parse --show-toplevel`
cd $git_repo

if [ ! -e bin ]; then
    echo "error: there is no bin directory underneath $git_repo"
    exit 1
fi

if [ ! -e bin/deploy.sh ]; then
    echo "error: there is no deploy.sh in $git_repo/bin"
    exit 1
fi

echo "executing $git_repo/bin/deploy.sh"
bin/deploy.sh

exit 0
