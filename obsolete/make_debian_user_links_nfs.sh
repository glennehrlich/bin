#!/bin/bash

# Assumes the following nfs mounts
#   mac:/Users/glenn   /Users/glenn
#   mac:/Users/glenn/r /home/glenn~/r

rm -f ~/.emacs.d
ln -s ~/r/emacs.d ~/.emacs.d

rm -f ~/.emacs.d.elpa
ln -s /Users/glenn/.emacs.d.elpa ~/.emacs.d.elpa

cd ~/.emacs.d
make create_persistent_dirs

rm -f ~/.fonts
ln -s ~/r/os/linux/home/glenn/.fonts ~/.fonts

rm -f ~/.bash_profile
ln -s ~/r/os/linux/home/glenn/.bash_profile ~/.bash_profile

rm -f ~/todo.org
ln -s ~/r/notes/todo.org ~/todo.org
