#!/usr/bin/env bash

cd ~/bc2/usr/bin

echo "starting redis server"
docker pull aga-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/bc2/bc2-redis/aga_redis_server:0.5.0-DEV
docker run --name redis --detach --tty --rm --publish 11500:11500 -v ~/bc2:/usr/data/storage --entrypoint /usr/bin/discovery_wrapper aga-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/bc2/bc2-redis/aga_redis_server:0.5.0-DEV --discovery_server 10.0.2.15:11080 --wrapper_config '{"running_ports":[11500], "running_keys_up": [{"name":"bc2/redis/10.0.2.15:11500"}] }' redis-server /usr/data/redis.conf --dir /usr/data/storage
sleep 5
