#!/bin/bash

echo ============================================================
echo "Checking repositories"
cd ~/r/notes
if [[ -n $(git status --porcelain) ]]; then
    echo "error: ~/r/notes is not ready to pull"
    echo ============================================================
    exit 1
else
    echo "~/r/notes is ready to push"
fi
cd ~/.emacs.d
if [[ -n $(git status --porcelain) ]]; then
    echo error: "~/.emacs.d is not ready to pull"
    echo ============================================================
    exit 1
else
    echo "~/.emacs.d is ready to pull"
fi
echo ============================================================
echo

echo ============================================================
echo Pull ~/r/notes
echo
cd ~/r/notes
make git_pull_origin
make permissions
echo

echo ============================================================
echo Pull ~/.emacs.d
echo
cd ~/.emacs.d
make git_pull_origin
echo

echo ============================================================
echo Completed
echo ============================================================
echo

