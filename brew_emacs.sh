#!/usr/bin/env bash

# 2020-08-08: d12frosted/emacs-plus now builds instead of installing from bottle

brew tap d12frosted/emacs-plus

brew uninstall --force emacs-plus@28
brew install emacs-plus@28
dockutil --remove Emacs
dockutil --add /usr/local/opt/emacs-plus@28/Emacs.app --after Safari
cd ~/.emacs.d
make update_elpa
make clean all
