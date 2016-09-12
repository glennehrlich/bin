#!/bin/bash

brew reinstall emacs --HEAD --with-cocoa --with-gnutls --with-imagemagick

open /usr/local/Cellar/emacs

echo
echo "Remove Emacs.app from dock."

echo
echo "Drag /usr/local/Cellar/emacs/HEAD*/Emacs.app to dock to the right of Safari icon."
