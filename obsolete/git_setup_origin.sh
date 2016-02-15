#!/bin/bash

echo ============================================================
echo Refreshing elpa
echo
cd ~/.emacs.d
make git_setup_origin
make update_elpa
make create_elpa_tar
echo

echo ============================================================
echo Setup ~/r/notes
echo
cd ~/r/notes
make git_setup_origin
echo

echo ============================================================
echo Push ~/.emacs.d
echo
cd ~/.emacs.d
make git_setup_origin
make clean all
echo

echo ============================================================
echo Completed
echo
echo On Windows VM, use FileZilla to ftp emacs.d.bundle, emacs.d.elpa.tar.gz, notes.bundle to tscdz1
echo ============================================================
echo

