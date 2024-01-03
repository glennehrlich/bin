#!/usr/bin/env bash

pkill -f tcservice
pkill -f rawtcp_altair
pkill -f to_redis
pkill -f tm_pub_service
pkill -f parameter
pkill -f sdbservice
pkill -f message
docker kill redis
