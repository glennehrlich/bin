#!/usr/bin/env bash

TC_INSTALL=~/bc2/usr/bin/tcservice
PM_INSTALL=~/bc2/usr/bin/parameter_manager_service

# ============================================================
# tcservice
# ============================================================

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
    pkill -f tcservice
fi
sleep 5
if pgrep tcservice; then
    echo "tcservice is still running, pkill -9 tcservice"
    pkill -f -9 tcservice
fi
sleep 2

if pgrep tcservice; then
    echo "tcservice is still running, can not install, exiting"
    exit 1
fi

echo "tcservice is not running, installing to $TC_INSTALL"
rm -f $TC_INSTALL
if [ -f $TC_INSTALL ]; then
    echo "$TC_INSTALL still exists, can not install"
    exit 1
fi

cp bin/tcservice $TC_INSTALL
if [ -f $TC_INSTALL ]; then
    echo "tcservice installed successfully"
else
    echo "tcservice failed to install"
    exit 1
fi

cp bin/send_tc ~/bc2/usr/bin
echo "send_tc installed"

# ============================================================
# parameter manager
# ============================================================

cd ~/git/bc2/parametermanager/build

if ! make parameter_manager_service; then
    echo "build failed, not installing"
    exit 1
fi

echo
echo "build succeeded, proceeding to installing"

sleep 2

if pgrep -f parameter_manager_service; then
    echo "paramter manager is running, pkill parameter_manager_service"
    pkill -f parameter_manager_service
fi
sleep 5
if pgrep -f parameter_manager_service; then
    echo "parameter_manager_service is still running, pkill -9 parameter_manager_service"
    pkill -f -9 parameter_manager_service
fi
sleep 2

if pgrep -f parameter_manager_service; then
    echo "parameter manager is still running, can not install, exiting"
    exit 1
fi

echo "parameter manager is not running, installing to $PM_INSTALL"
rm -f $PM_INSTALL
if [ -f $PM_INSTALL ]; then
    echo "$PM_INSTALL still exists, can not install"
    exit 1
fi

cp bin/parameter_manager_service $PM_INSTALL
if [ -f $PM_INSTALL ]; then
    echo "parameter manager installed successfully"
else
    echo "parameter manager failed to install"
    exit 1
fi

exit 0
