#!/usr/bin/env BASH

options="-e"

mgitstatus $options ~/.emacs.d       1
mgitstatus $options ~/.ssh           1
mgitstatus $options ~/bin            1
mgitstatus $options ~/dot-files      1
mgitstatus $options ~/gitlab         5
mgitstatus $options ~/notes          1
mgitstatus $options ~/notes-personal 1
mgitstatus $options ~/repos          2
mgitstatus $options ~/todo           1
