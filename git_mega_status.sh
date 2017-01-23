#!/bin/bash

function git_status {
    local dir=$1

    echo "------------------------------------------------------------"
    echo "checking $dir"
    git rev-parse --abbrev-ref HEAD # show current checked out branch
    cd $dir
    if [[ -n $(git status --porcelain) ]]; then
        echo "error: $dir is not clean"
    fi
}

# /gitlab/kinetx_forks
git_status /gitlab/kinetx_forks/czml
git_status /gitlab/kinetx_forks/mice
git_status /gitlab/kinetx_forks/pypdevs
git_status /gitlab/kinetx_forks/python-wrapper-main

# /gitlab/kinetx_glenn
git_status /gitlab/kinetx_glenn/design
git_status /gitlab/kinetx_glenn/examples
git_status /gitlab/kinetx_glenn/python
git_status /gitlab/kinetx_glenn/sims

# /gitlab/kinext_python
git_status /gitlab/kinetx_python/k
git_status /gitlab/kinetx_python/k_releases

# Personal repos on github
git_status ~/.emacs.d

echo "------------------------------------------------------------"
echo "finished"
exit 0
