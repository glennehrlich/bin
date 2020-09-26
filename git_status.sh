#!/usr/bin/env bash

options="-e --depth=1"

mgitstatus $options ~/.emacs.d
mgitstatus $options ~/.aws
mgitstatus $options ~/.ssh
mgitstatus $options ~/bin
mgitstatus $options ~/dot-files
# mgitstatus $options ~/gitlab
# mgitstatus $options ~/gitlab-archive
mgitstatus $options ~/notes
mgitstatus $options ~/notes-personal
mgitstatus $options ~/todo
