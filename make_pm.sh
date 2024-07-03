#!/usr/bin/env bash

PM_INSTALL=~/bc2/usr/bin/parameter_manager_service

# ============================================================
# parameter manager
# ============================================================

cd ~/git/bc2/parametermanager/build

if ! make parameter_manager_service set_parameter get_parameter ; then
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

cp bin/get_parameter ~/bc2/usr/bin
cp bin/set_parameter ~/bc2/usr/bin

exit 0
