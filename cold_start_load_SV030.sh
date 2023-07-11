#!/usr/bin/env bash

echo "clearing logs"
rm -f ~/bc2/usr/log/*

cd ~/bc2/usr/bin

./add_assets -a SV030 -c spacecraft -t MSS

./loaddatabase -a SV030 -x ~/bc2/usr/etc/SV030_7.0.xml

load_ground_parameters_SV030.sh

activate_sv030.sh

