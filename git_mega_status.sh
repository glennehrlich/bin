#!/bin/bash

source git_mega_repos.sh

function git_status {
    local dir=$1

    echo "------------------------------------------------------------"
    echo "checking $dir"
    cd $dir
    git rev-parse --abbrev-ref HEAD # show current checked out branch
    if [[ -n $(git status --porcelain) ]]; then
        echo "warning: $dir is not clean"
        return 1
    else
        return 0
    fi
}

status=0
unclean_repos=()
for repo in ${GIT_REPOS[@]}; do
    if ! git_status $repo; then
        status=1
        unclean_repos+=($repo)
    fi
done

echo
echo "------------------------------------------------------------"
if [ $status == 0 ]; then
    echo "all repos are clean"
else
    echo "the following repos are not clean:"
    for r in ${unclean_repos[@]}; do
        echo "$r"
    done
fi
exit 0
