#!/bin/bash

rm -rf ~/r
ln -s /media/psf/Home/r ~/r

rm -rf ~/.emacs.d
ln -s /media/psf/Home/r/emacs.d ~/.emacs.d

rm -rf ~/.emacs.d.elpa
ln -s /media/psf/Home/.emacs.d.elpa ~/.emacs.d.elpa

cd ~/.emacs.d
make create_persistent_dirs

rm -rf ~/.fonts
ln -s /media/psf/Home/r/os/linux/home/glenn/.fonts ~/.fonts

# rm -rf ~/.fonts.conf
# ln -s /media/psf/Home/r/os/linux/home/glenn/.fonts.conf ~/.fonts.conf

