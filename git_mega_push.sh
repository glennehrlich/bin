#!/bin/bash

source git_mega_repos.sh

function git_push {
    local dir=$1

    echo "------------------------------------------------------------"
    echo "pushing $dir"
    cd $dir
    if [[ -n $(git status --porcelain) ]]; then
        echo "error: $dir is not clean"
        exit 1
    fi
    git push origin --all
    git push origin --tags
}

for repo in ${GIT_REPOS[@]}; do
    git_push $repo
done

echo "------------------------------------------------------------"
echo "finished"
exit 0
