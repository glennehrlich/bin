#!/usr/bin/env bash

# Necessary to run stuff in pipe in current process (while read dir; do)
shopt -s lastpipe

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

for gr in ${GIT_REPOS[@]}; do
    find $gr -name .git -type d -prune | while read dir; do
        repo=$(dirname $dir)
        cd $repo
        git_push $repo
    done
done

echo "------------------------------------------------------------"
echo "finished"
exit 0
