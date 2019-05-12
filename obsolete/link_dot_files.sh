#!/usr/bin/env bash

# .bash_profile
if [ -e ~/.bash_profile ]; then
  mv ~/.bash_profile ~/.bash_profile.original
fi
ln -s ~/r/bash/dot.bash_profile ~/.bash_profile

# .bashrc
if [ -e ~/.bashrc ]; then
  mv ~/.bashrc ~/.bashrc.original
fi
ln -s ~/r/bash/dot.bashrc ~/.bashrc

# .emacs
if [ -e ~/.emacs ]; then
  mv ~/.emacs ~/.emacs.original
fi
ln -s ~/r/emacs/dot.emacs ~/.emacs

# .gitconfig
if [ -e ~/.gitconfig ]; then
  mv ~/.gitconfig ~/.gitconfig.original
fi
ln -s ~/r/git/dot.gitconfig ~/.gitconfig

# .sbclrc
if [ -e ~/.sbclrc ]; then
  mv ~/.sbclrc ~/.sbclrc.original
fi
ln -s ~/r/sbcl/dot.sbclrc ~/.sbclrc

# .w3m
if [ -e ~/.w3m ]; then
  mv ~/.w3m ~/.w3m.original
fi
ln -s ~/r/w3m ~/.w3m


