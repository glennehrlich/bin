#!/usr/bin/env bash

# Necessary to run stuff in pipe in current process (while read dir; do)
shopt -s lastpipe

source git_mega_repos.sh

function git_status {
    local dir=$1

    # echo "------------------------------------------------------------"
    # echo "checking $dir"
    cd $dir
    # git rev-parse --abbrev-ref HEAD # show current checked out branch
    if [[ -n $(git status --porcelain) ]]; then
        # echo "warning: $dir is not clean"
        return 1
    else
        return 0
    fi
}

exit_code=0

status=0
declare -x unclean_repos
unclean_repos=()
for gr in ${GIT_REPOS[@]}; do
    find $gr -name .git -type d -prune | while read dir; do
        repo=$(dirname $dir)
        if ! git_status $repo; then
            status=1
            unclean_repos+=($repo)
            exit_code=1
        fi
    done
done

echo
echo "------------------------------------------------------------"
if [ $status == 0 ]; then
    echo "all repos are clean"
else
    echo "The following repos are not clean:"
    for r in ${unclean_repos[@]}; do
        branch=$(git rev-parse --abbrev-ref HEAD)
        echo "$r on $branch"
    done
fi

exit $exit_code
