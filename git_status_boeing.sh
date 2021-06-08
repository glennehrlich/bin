#!/usr/bin/env bash

# options="-e --depth=0"
options="-f --depth=0"

mgitstatus $options ~/.emacs.d
mgitstatus $options ~/.ssh
mgitstatus $options ~/bin
mgitstatus $options ~/dot-files
mgitstatus $options ~/g
mgitstatus $options ~/git
mgitstatus $options ~/github
mgitstatus $options ~/notes
mgitstatus $options ~/notes-personal
mgitstatus $options ~/todo
