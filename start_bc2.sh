#!/usr/bin/env bash

echo "clearing logs"
rm -f ~/bc2/usr/etc/log/*

cd ~/bc2/usr/bin

echo "starting redis servier"
docker run --name redis --detach --tty --rm --publish 11500:11500 -v ~/bc2:/usr/data/storage bc2-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/bc2/redis-server:6.2.6-R1 /usr/data/redis.conf --dir /usr/data/storage
sleep 5

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
