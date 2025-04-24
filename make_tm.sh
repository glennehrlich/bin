#!/usr/bin/env bash

INSTALL=~/bc2/usr/bin/tm_pub_service

cd ~/git/bc2/tmservice/build

if ! make tm_pub_service; then
    echo "build failed, not installing"
    exit 1
fi

echo
echo "build succeeded, proceeding to installing"

sleep 2

if pgrep tm_pub_service; then
    echo "tm_pub_service is running, pkill tm_pub_service"
    pkill tm_pub_service
fi
sleep 5
if pgrep tm_pub_service; then
    echo "tm_pub_service is still running, pkill -9 tm_pub_service"
    pkill -9 tm_pub_service
fi
sleep 2

if pgrep tm_pub_service; then
    echo "tm_pub_service is still running, can not install, exiting"
    exit 1
fi

echo "tm_pub_service is not running, installing to $INSTALL"
rm -f $INSTALL
if [ -f $INSTALL ]; then
    echo "$INSTALL still exists, can not install"
    exit 1
fi

cp bin/tm_pub_service $INSTALL
if [ -f $INSTALL ]; then
    echo "tm_pub_service installed successfully"
else
    echo "tm_pub_service failed to install"
    exit 1
fi

exit 0
