#!/usr/bin/env bash

# Syntax
# git_remote_add.sh
#
# Takes the path of current git repo minus the $HOME portion, creates
# the same directory on the remote (using it's $HOME), git inits a
# bare repository in the remote dir, and then sets the current git
# repo's remote origin to the remote.
#
# For example, if the user's current git repo is
# /home/glenn/g/my_git_repo and the remote system's $HOME is
# /home1/um268c, then this script will create
# /home1/um268c/g/my_git_repo, git init it as a bare repository and
# then set the current git repo's remote origin to
# $host:/home1/um268c/g/my_git_repo.
#
# Assumes that password-less ssh operations for $user@$host will work.

# The remote user.
user=um268c

# The remote host.
host=dev-1

# Test if within a git repository.
if ! git rev-parse --is-inside-work-tree  > /dev/null 2>&1; then
    echo "error: not inside a git repository"
    exit 1
fi

# Get the full path to the current git repo's top level, i.e.,
# /home/glenn/g/my_git_repo.
full_repo=$(git rev-parse --show-toplevel)

# Strip off $HOME from full_repo, i.e., g/my_git_repo.
partial_repo=${full_repo#$HOME/}

# Get the remote home dir. -q suppresses the unauthorized use message
# when doing ssh, i.e., /home1/um268c.
remote_home=$(ssh -q $user@$host 'echo $HOME')

# Make the full path of the remote repo, i.e.,
# /home1/um268c/g/my_git_repo.
remote_repo=$remote_home/$partial_repo

# Make the remote_repo dir on the remote system. This is not an error
# if the dir already exits.
ssh -q $user@$host "mkdir -p $remote_repo"

# Check that remote_repo exists, exit if it does not.
if ! ssh -q $user@$host "[ -d $remote_repo ]"; then
    echo "$host:$remote_repo does not exist"
    exit 1
fi

# Init a bare repo in remote_repo.
ssh -q $user@$host "git init --quiet --bare $remote_repo"

# Add the remote repo to this repo.
git remote add origin $host:$remote_repo
