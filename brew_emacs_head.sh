#!/bin/bash

if pstree -p $PPID | grep -v grep | grep -q -i emacs; then
    echo "error: you can not run this script from within emacs (because emacs will be removed and installed)."
    exit 1
fi

echo "brewing with emacs HEAD"
brew uninstall --force emacs
brew install emacs --HEAD --with-cocoa --with-gnutls --with-imagemagick@6 --with-librsvg --with-mailutils --with-modules
dockutil --remove Emacs
dockutil --add /usr/local/Cellar/emacs/HEAD*/Emacs.app --after Safari
