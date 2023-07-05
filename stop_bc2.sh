#!/usr/bin/env bash

pkill tcservice
pkill rawtcp_altair_g
pkill to_redis
pkill tm_pub_service
pkill parameter_manager_service
pkill sdbservice
pkill message_distributor_proxy
docker kill redis
