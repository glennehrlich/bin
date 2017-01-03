#!/bin/bash

echo "brewing with emacs HEAD"
brew uninstall emacs
brew install emacs --HEAD --with-cocoa --with-gnutls --with-imagemagick --with-mailutils --with-modules

open /usr/local/Cellar/emacs

echo
echo "Remove Emacs.app from dock."

echo
echo "Drag /usr/local/Cellar/emacs/HEAD*/Emacs.app to dock to the right of Safari icon."
