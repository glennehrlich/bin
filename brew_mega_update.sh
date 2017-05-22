#!/bin/bash

ask_sudo() {
  echo "This script needs the sudo password."
  read -s -p 'Password:' sudo_password
  echo
  sudo --stdin --validate <<< "${sudo_password}" 2> /dev/null
  until sudo -n true 2> /dev/null; do
    read -s -p 'Password:' sudo_password
    echo
    sudo --stdin --validate <<< "${sudo_password}" 2> /dev/null
  done
}

renew_sudo() {
  sudo --stdin --validate <<< "${sudo_password}" 2> /dev/null
}

if pstree -p $PPID | grep -v grep | grep -q -i emacs; then
    echo "error: you can not run this script from within emacs (because emacs will be removed and installed)."
    exit 1
fi

ask_sudo

echo "------------------------------------------------------------"
echo "pruning brew"
brew prune

echo "------------------------------------------------------------"
echo "updating brew"
brew update

echo "------------------------------------------------------------"
echo "upgrading brew"
brew upgrade

echo "------------------------------------------------------------"
echo "updating emacs"
brew uninstall --force emacs
brew install emacs --HEAD --with-cocoa --with-gnutls --with-imagemagick@6 --with-librsvg --with-mailutils --with-modules
dockutil --remove Emacs
dockutil --add /usr/local/Cellar/emacs/HEAD*/Emacs.app --after Safari
cd ~/.emacs.d
make update_elpa
make clean all

for i in $(brew cask outdated --quiet); do 
    echo "------------------------------------------------------------"
    echo "updating $i"
    brew cask fetch $i
    renew_sudo
    brew cask install --force $i
    echo
done    

echo "------------------------------------------------------------"
echo "cleaning up brew"
brew cask cleanup

echo "------------------------------------------------------------"
echo "finished"
exit 0
