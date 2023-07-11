#!/usr/bin/env bash

pkill tcservice
pkill rawtcp_altair_g
pkill to_redis
pkill tm_pub_service
pkill parameter
pkill sdbservice
pkill message
docker kill redis
