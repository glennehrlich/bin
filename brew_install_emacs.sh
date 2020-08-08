#!/usr/bin/env bash

brew tap d12frosted/emacs-plus

brew uninstall --force emacs-plus@28
brew install emacs-plus@28 --with-jansson
dockutil --remove Emacs
dockutil --add /usr/local/opt/emacs-plus@28/Emacs.app --after Safari
cd ~/.emacs.d
make update_elpa
make clean all
