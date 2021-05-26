#!/usr/bin/env bash

# options="-e --depth=0"
options="-f --depth=0"

mgitstatus $options ~/.emacs.d
mgitstatus $options ~/.ssh
mgitstatus $options ~/bin
mgitstatus $options ~/dot-files
mgitstatus $options ~/gitlab
# mgitstatus $options ~/gitlab-archive
mgitstatus $options ~/notes
mgitstatus $options ~/notes-personal
mgitstatus $options ~/todo
