#!/usr/bin/env bash

INSTALL=~/bc2/usr/bin/tcservice

cd ~/git/bc2/tcservice/build

if ! make tcservice send_tc; then
    echo "build failed, not installing"
    exit 1
fi

echo
echo "build succeeded, proceeding to installing"

sleep 2

if pgrep tcservice; then
    echo "tcservice is running, pkill tcservice"
    pkill tcservice
fi
sleep 5
if pgrep tcservice; then
    echo "tcservice is still running, pkill -9 tcservice"
    pkill -9 tcservice
fi
sleep 2

if pgrep tcservice; then
    echo "tcservice is still running, can not install, exiting"
    exit 1
fi

echo "tcservice is not running, installing to $INSTALL"
rm -f $INSTALL
if [ -f $INSTALL ]; then
    echo "$INSTALL still exists, can not install"
    exit 1
fi

cp bin/tcservice $INSTALL
if [ -f $INSTALL ]; then
    echo "tcservice installed successfully"
else
    echo "tcservice failed to install"
    exit 1
fi

cp bin/send_tc ~/bc2/usr/bin
echo "send_tc installed"

exit 0
