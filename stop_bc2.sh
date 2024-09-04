#!/usr/bin/env bash

pkill -f tcservice
pkill -f rawtcp_altair
pkill -f to_redis
pkill -f tm_pub_service
pkill -f eventservice
pkill -f parameter
pkill -f sdbservice
docker stop mss_sim_sv030
pkill -f message

echo "sleeping for 5 seconds to allow services to cleanly stop before stopping redis"
sleep 5
docker stop redis

echo "sleeping for 5 seconds after stopping redis before stopping etcd-server"
sleep 5
docker stop etcd-server

