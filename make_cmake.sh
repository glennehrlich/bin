#!/usr/bin/env bash

RELEASE=3.25
VERSION=$RELEASE.2

mkdir -p ~/tmp

cd ~/tmp

rm -rf cmake-${RELEASE}*

wget https://${SRESUSER}:${SRESAPIKEY}@sres.web.boeing.com/artifactory/cmake-remote-cache/v${RELEASE}/cmake-${VERSION}.tar.gz

tar -xvf cmake-${VERSION}.tar.gz

cd cmake-${VERSION}

./bootstrap --prefix=/opt/cmake-${VERSION}

make

sudo make install
