#!/bin/bash

function git_push {
    local dir=$1

    echo "------------------------------------------------------------"
    echo "pushing $dir"
    cd $dir
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

# /gitlab/kinext_python
git_push /gitlab/kinetx_python/k
git_push /gitlab/kinetx_python/k_releases

echo "------------------------------------------------------------"
echo "finished"
