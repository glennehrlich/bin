#!/usr/bin/env bash

ln -s /media/psf/Home/r ~/r

rm -rf ~/.emacs.d
ln -s /media/psf/Home/r/emacs.d ~/.emacs.d

ln -s /media/psf/Home/.emacs.d.elpa ~/.emacs.d.elpa

cd ~/.emacs.d
make create_persistent_dirs

ln -s /media/psf/Home/r/os/linux/home/glenn/.fonts ~/.fonts
