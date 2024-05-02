#!/usr/bin/env bash

cd ~/bc2/usr/bin

add_rawtcp_gep_asset.sh mss_sim_sv030 127.0.0.1 32100 32000

set_parameter -a mss_sim_sv030 -p bc2_prop_tm_max_ground_frame -v 512

add_assets -a sv030-int-1 -c service -t streamgateway


# ./loaddatabase -a SV030 -c spacecraft -t MSS --activate -x ~/bc2/usr/etc/SV030_7.0.xml
./loaddatabase -a SV030 -c spacecraft -t MSS --activate -x ~/bc2/usr/etc/SV030_7.0-constraint.xml
