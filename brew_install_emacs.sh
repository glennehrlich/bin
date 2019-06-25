#!/usr/bin/env bash

brew tap d12frosted/emacs-plus

brew uninstall --force emacs-plus
brew install emacs-plus --without-spacemacs-icon
dockutil --remove Emacs
dockutil --add /usr/local/opt/emacs-plus/Emacs.app --after Safari
cd ~/.emacs.d
make update_elpa
make clean all
