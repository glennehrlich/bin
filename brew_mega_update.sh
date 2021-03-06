#!/usr/bin/env bash

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
echo "cleaning up brew"
brew cleanup

echo "------------------------------------------------------------"
echo "updating brew"
brew update

echo "------------------------------------------------------------"
echo "upgrading brew"
brew upgrade

echo "------------------------------------------------------------"
echo "updating emacs"
brew_emacs.sh

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
brew cleanup

echo "------------------------------------------------------------"
echo "finished"
exit 0
