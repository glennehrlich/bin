#!/usr/bin/env bash

cd ~/bc2/usr/bin

./message_distributor_proxy -p 127.0.0.1:28455 -s 127.0.0.1:28456 &
sleep 5

./message_distributor_proxy -p 127.0.0.1:28457 -s 127.0.0.1:28458 &
sleep 5

./sdbservice &
sleep 10

./tm_pub_service --assets SV030 &
sleep 5

./rawtcp_altair_gateway  --name streamgateway --gateway_id "deploy-test" --rawtcp_tm_hostport 127.0.0.1:32100 --rawtcp_tc_hostport 127.0.0.1:32000 --tc_listen_hostport 0.0.0.0:28465 --max_tm_framecount 4095 &
sleep 5

./tcservice --streamgateway 127.0.0.1:28465 --assets SV030 &
sleep 5
