#!/usr/bin/env bash

# make_master_sbcl.sh VERSION
# make_master_sbcl.sh sbcl-1.1.2

# Revision history
# 2013/01/02: sudo not necessary

VERSION=$1

cd $HOME

echo "glenn: building sbcl version $VERSION"
make_sbcl.sh $VERSION

echo "glenn: getting latest slime"
cd $HOME
make_slime.sh

echo "glenn: updating quicklisp client"
cd $HOME
sbcl --eval '(progn (ql:update-client) (quit))'

echo "glenn: updating quicklisp"
cd $HOME
sbcl --eval '(progn (ql:update-dist "quicklisp") (quit))'

echo "glenn: dumping core"
cd $HOME/r/lisp/dumped-cores
./make-sbcl.sh

cd $HOME

echo "glenn: finished"

