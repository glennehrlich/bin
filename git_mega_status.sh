#!/bin/bash

source git_mega_repos.sh

function git_status {
    local dir=$1

    echo "------------------------------------------------------------"
    echo "checking $dir"
    cd $dir
    git rev-parse --abbrev-ref HEAD # show current checked out branch
    if [[ -n $(git status --porcelain) ]]; then
        echo "error: $dir is not clean"
    fi
}

for repo in ${GIT_REPOS[@]}; do
    git_status $repo
done

echo "------------------------------------------------------------"
echo "finished"
exit 0
