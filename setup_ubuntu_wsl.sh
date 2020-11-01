#!/usr/bin/env bash

# the idea here is to pull all the different stuff from provision
# scripts and stuff i have in ~/bin




# these are the apt-get installs i did in wsl2

   26  sudo apt-get install emacs
   94  sudo apt-get install bash-completion
  109  sudo apt-get install xterm
  111  sudo apt-get install xterm
  114  sudo apt-get install synaptic
  119  sudo apt install emacs27
  152  sudo apt-get install libvterm
  153  sudo apt-get install cmake
  155  sudo apt-get install libtool-bin
  156  sudo apt-get install libvterm-dev
  158  sudo apt-get install ripgrep
  193  sudo apt-get uninstall emacs27
  199  sudo apt --fix-borken install
  200  sudo apt-get install emacs-snapshot emacs-snapshot-el emacs-snapshot-common
  203  sudo apt-get install -y emacs-snapshot emacs-snapshot-el
  204  sudo apt-get install -y emacs-snapshot emacs-snapshot-el emacs-snapshot-common
  206  sudo apt-get install -y emacs-snapshot emacs-snapshot-el emacs-snapshot-common
  210  sudo apt-get install -y emacs-snapshot emacs-snapshot-el emacs-snapshot-common
  215  sudo apt-get install emacs-snapshot emacs-snapshot-el
  268  sudo apt-get install dbus-x11


mkdir ~/github
mkdir ~/gitlab
mkdir ~/tmp

# install ripgrep
cd ~/tmp
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
sudo dpkg -i ripgrep_12.1.1_amd64.deb 

# install multi-git-status
cd ~/github
git clone git@github.com:fboender/multi-git-status.git
