#!/usr/bin/env bash

brew tap d12frosted/emacs-plus

echo "brewing with emacs-plus HEAD"
brew uninstall --force emacs-plus@28
brew install emacs-plus@28 --HEAD --with-cocoa --with-imagemagick@6 --with-librsvg --with-mailutils --with-modules --with-jansson
dockutil --remove Emacs
dockutil --add /usr/local/opt/emacs-plus@28/Emacs.app --after Safari
cd ~/.emacs.d
make update_elpa
make clean all
