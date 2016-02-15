#!/bin/bash

echo ============================================================
echo "Checking repositories"
cd ~/r/notes
if [[ -n $(git status --porcelain) ]]; then
    echo "error: ~/r/notes is not ready to push"
    echo ============================================================
    exit 1
else
    echo "~/r/notes is ready to push"
fi
cd ~/.emacs.d
if [[ -n $(git status --porcelain) ]]; then
    echo error: "~/.emacs.d is not ready to push"
    echo ============================================================
    exit 1
else
    echo "~/.emacs.d is ready to push"
fi
echo ============================================================
echo

echo ============================================================
echo Refreshing elpa
echo
cd ~/.emacs.d
make update_elpa
make create_elpa_tar
make clean all
echo

echo ============================================================
echo Push ~/r/notes
echo
cd ~/r/notes
make git_push_origin
echo

echo ============================================================
echo Push ~/.emacs.d
echo
cd ~/.emacs.d
make git_push_origin
echo

echo ============================================================
echo Completed
echo
echo On Windows VM, use FileZilla to ftp emacs.d.bundle, emacs.d.elpa.tar.gz, notes.bundle to tscdz1
echo ============================================================
echo

