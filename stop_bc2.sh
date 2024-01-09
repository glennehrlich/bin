#!/usr/bin/env bash

pkill -f tcservice
pkill -f rawtcp_altair
pkill -f to_redis
pkill -f tm_pub_service
pkill -f parameter
pkill -f sdbservice
docker kill mss_sim_sv030
pkill -f message
docker kill redis
echo "sleeping for 5 seconds"
sleep 5
docker kill etcd-server
