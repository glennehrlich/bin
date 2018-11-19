#!/bin/bash

echo "brewing with emacs release"
brew uninstall --force emacs
brew install emacs --with-cocoa --with-imagemagick@6 --with-librsvg --with-mailutils --with-modules
dockutil --remove Emacs
dockutil --add /usr/local/Cellar/emacs/HEAD*/Emacs.app --after Safari
