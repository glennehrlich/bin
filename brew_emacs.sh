#!/usr/bin/env bash

brew tap d12frosted/emacs-plus

echo "brewing with emacs-plus HEAD"
brew uninstall --force emacs-plus
brew install emacs-plus --HEAD --with-cocoa --with-imagemagick@6 --with-librsvg --with-mailutils --with-modules --with-jansson --without-spacemacs-icon
dockutil --remove Emacs
dockutil --add /usr/local/opt/emacs-plus/Emacs.app --after Safari
cd ~/.emacs.d
make update_elpa
make clean all