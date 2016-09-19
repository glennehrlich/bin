#!/bin/bash

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

# /gitlab/kinetx_forks
git_push /gitlab/kinetx_forks/czml
git_push /gitlab/kinetx_forks/mice
git_push /gitlab/kinetx_forks/pypdevs
git_push /gitlab/kinetx_forks/python-wrapper-main

# /gitlab/kinetx_glenn
git_push /gitlab/kinetx_glenn/design
git_push /gitlab/kinetx_glenn/examples
git_push /gitlab/kinetx_glenn/python
git_push /gitlab/kinetx_glenn/sims

# /gitlab/kinext_python
git_push /gitlab/kinetx_python/k
git_push /gitlab/kinetx_python/k_releases

echo "------------------------------------------------------------"
echo "finished"
exit 0
