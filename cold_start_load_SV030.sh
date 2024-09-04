#!/usr/bin/env bash

cd ~/bc2/usr/bin

# ./loaddatabase -a SV030 -c spacecraft -t MSS --activate -x ~/bc2/usr/etc/SV030_7.0.xml
./loaddatabase -a SV030 -c spacecraft -t MSS --activate -x ~/bc2/usr/etc/SV030_7.0-constraint.xml

# ./loaddatabase -a SV030 -c spacecraft -t MSS --activate -x ~/bc2/usr/etc/SV030_7.0-glenn.xml
# ./loaddatabase -a SV030 -c spacecraft -t MSS --activate -x ~/tmp/sv030/SV030_7.0-glenn.xml
