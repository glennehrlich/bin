#!/usr/bin/env bash

echo "clearing logs"
rm -f ~/bc2/usr/etc/log/*

cd ~/bc2/usr/bin

echo "starting event distributer"
./message_distributor_proxy --name event_distributor_proxy1 &
sleep 5

echo "starting telemetry distributor"
./message_distributor_proxy -n telemetry_distributor_proxy1 &
sleep 5

# echo "starting sdbservice"
# ./sdbservice --no_unique_name &
# sleep 10
echo "need to manually start sdbservice; run: ./sdbservice --no_unique_name"

echo "starting tm_pub_service"
./tm_pub_service &
sleep 5

echo "starting stream gateway"
./rawtcp_altair_gateway  --name streamgateway --gateway_id "deploy-test" --max_tm_framecount 4095 &
sleep 5

# ./tcservice --assets SV030 &
# sleep 5
echo "need to manually start tcservice"
