#!/usr/bin/env bash

cd ~/bc2/usr/bin

echo "starting redis servier"
docker run --name redis --detach --tty --rm --publish 11500:11500 -v ~/bc2:/usr/data/storage bc2-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/bc2/redis-server:6.2.6-R1 /usr/data/redis.conf --dir /usr/data/storage
sleep 5
