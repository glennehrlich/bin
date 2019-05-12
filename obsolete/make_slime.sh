#!/usr/bin/env bash

# cd ~/r/cots
# cvs -d :pserver:anonymous:anonymous@common-lisp.net:/project/slime/cvsroot co slime

# cd ~/.slime.d
# git pull origin master

cd ~
rm -rf .slime.d.old
mv .slime.d .slime.d.old
cvs -d :pserver:anonymous:anonymous@common-lisp.net:/project/slime/cvsroot co slime
mv slime .slime.d
