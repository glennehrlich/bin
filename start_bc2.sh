#!/usr/bin/env bash

cd ~/bc2/usr/bin

echo "clearing logs"
rm -f ~/bc2/usr/log/*

echo "clearing sdbservice lock file"
rm -f ~/bc2/usr/data/sdb/xtce/.sdbservice_lock

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
# echo "need to manually start sdbservice; run: ./sdbservice --no_unique_name"
echo "starting sdbservice cold"
# ./sdbservice --no_unique_name        & # warm
# ./sdbservice --no_unique_name --no_unsupported_encoding --cold & # cold
# ./sdbservice --no_unique_name --no_unsupported_encoding & # warm and BogusSAT
./sdbservice --cold --no_unique_name --no_unsupported_encoding & # cold and BogusSAT
sleep 10

echo "starting parameter manager cold"
# ./parameter_manager_service --redis_password 1234abcd              & # warm
./parameter_manager_service --redis_password 1234abcd --cold_start & # cold
sleep 5
# echo "need to manually start tcservice:"
# echo "./parameter_manager_service --redis_password 1234abcd"

echo "starting tm_pub_service"
./tm_pub_service &
sleep 5

echo "starting to_redis"
./to_redis --redis_password 1234abcd --assets SV030 &
sleep 5

echo "starting stream gateway"
./rawtcp_altair_gateway  --name streamgateway --gateway_id "deploy-test" --max_tm_framecount 4095 &
sleep 5

echo "cold loading sdbservice"
cold_start_load_SV030.sh
cold_start_load_O3b_F01.sh

# Cold loading parameter manager is no longer necessary.
# echo "cold loading parameter manager"
# load_ground_parameters_SV030.sh
# load_ground_parameters_O3b_F01.sh
# echo "skipping cold loading parameter manager"

echo "starting tcservice"
# ./tcservice &
# sleep 5
echo "need to manually start tcservice"
