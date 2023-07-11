#!/usr/bin/env bash

echo "clearing logs"
rm -f ~/bc2/usr/log/*

cd ~/bc2/usr/bin

./add_assets -a O3b_F01 -c spacecraft -t 702

./loaddatabase -a O3b_F01 -x ~/bc2/usr/etc/O3b_F01_no_fsw.xml 

load_ground_parameters_O3b_F01.sh

activate_sv030.sh

