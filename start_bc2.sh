#!/usr/bin/env bash

# References to 10.0.2.15 might need to change. It has to reference
# the IP address of the ethernet adaptor inside of the VM. It's
# difficult to make shell variable substitution work with the way
# these command lines look, so they're hardcoded.

cd ~/bc2/usr/bin

echo "clearing logs"
rm -f ~/bc2/usr/log/*

echo "clearing sdbservice lock file"
rm -f ~/bc2/usr/data/sdb/xtce/.sdbservice_lock

echo "starting etcd"
docker pull aga-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/bc2/etcd-server:3.5.9-R4
docker run --name etcd-server --detach --tty --rm --publish 11080:11080 \
-v /var/bc2/usr/data/etcd:/etcd-data \
--entrypoint /usr/bin/delay_shutdown.bash \
aga-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/bc2/etcd-server:3.5.9-R4 \
60 /usr/bin/etcd \
--name discovery1 --data-dir /etcd-data \
--listen-client-urls http://0.0.0.0:11080 --advertise-client-urls http://0.0.0.0:11080 \
--listen-peer-urls http://0.0.0.0:11081 --initial-advertise-peer-urls http://0.0.0.0:11081 \
--initial-cluster discovery1=http://0.0.0.0:11081 --initial-cluster-token aga-disco-tkn \
--initial-cluster-state new --log-level info --logger zap --log-outputs stderr
sleep 5

echo "starting redis server"
docker pull aga-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/bc2/bc2-redis/aga_redis_server:0.5.0-DEV
docker run --name redis --detach --tty --rm --publish 11500:11500 -v ~/bc2:/usr/data/storage --entrypoint /usr/bin/discovery_wrapper aga-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/bc2/bc2-redis/aga_redis_server:0.5.0-DEV --discovery_server 10.0.2.15:11080 --wrapper_config '{"running_ports":[11500], "running_keys_up": [{"name":"bc2/redis/10.0.2.15:11500"}] }' redis-server /usr/data/redis.conf --dir /usr/data/storage
sleep 5

echo "starting tc status and event proxy"
./discovery_wrapper \
--wrapper_config '{"running_keys_down": [{"name":"bc2/event_publisher_proxy/500/10.0.2.15:11600"}, {"name":"bc2/event_distributor_proxy/500/10.0.2.15:11601"}] }' \
~/bc2/usr/bin/message_distributor_proxy \
--discovery_server 10.0.2.15:11080 --upstream_port 11600 --downstream_port 11601 -q 500 --event &

echo "starting tm proxy"
./discovery_wrapper \
--wrapper_config '{"running_keys_down": [{"name":"bc2/parameter_publisher_proxy/500/10.0.2.15:11620"}, {"name":"bc2/telemetry_distributor_proxy/500/10.0.2.15:11621"}] }' \
~/bc2/usr/bin/message_distributor_proxy \
--discovery_server 10.0.2.15:11080 --upstream_port 11620 --downstream_port 11621 -q 500 &

echo "starting SV030 mss sim"
docker run --name mss_sim_sv030 --detach --tty --rm --publish 32000:32000 --publish 32100:32100 bc2-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/mss/palermo/sw_sim_docker_image:boeing_ground_dist_2
sleep 5

echo "starting sdbservice cold"
./discovery_wrapper \
--discovery_server 10.0.2.15:11080 \
--wrapper_config '{"before_waitfor_keys": [{"name": "bc2/event_publisher_proxy/"}], "running_ports":[11505], "running_keys_up": [{"name":"bc2/asset_manager/10.0.2.15:11505"}]}' \
/usr/bin/jemalloc.sh ~/bc2/usr/bin/sdbservice --no_unique_name --cold --no_unsupported_encoding --log_level debug &

echo "starting parameter manager"
./discovery_wrapper \
--discovery_server 10.0.2.15:11080 \
--wrapper_config '{"cmd_line_name_keys": [{"parameter":"--evtsource", "name":"bc2/event_distributor_proxy/"}, {"parameter":"--sdbservice", "name":"bc2/asset_manager/", "use_all_up": false, "split_host_port":true}, {"parameter":"--redis", "name":"bc2/redis/", "use_all_up": false, "split_host_port":true} ], "running_ports":[11510], "running_keys_up": [{"name":"bc2/parameter_manager_service/10.0.2.15:11510"}]}' \
/usr/bin/jemalloc.sh ~/bc2/usr/bin/parameter_manager_service --redis_password 1234abcd &

# space python can't send to event service; not sure if it's being set up correctly, so disabling for now
# echo "starting event service"
# ./discovery_wrapper \
# --discovery_server 10.0.2.15:11080 \
# --wrapper_config '{"before_waitfor_keys": [{"name":"bc2/event_publisher_proxy/"}, {"name":"bc2/asset_manager/"}], "running_ports":[11530], "running_keys_up": [{"name":"bc2/eventservice/10.0.2.15:11530"}]}' \
# /usr/bin/jemalloc.sh ~/bc2/usr/bin/eventservice &

echo "starting SV030 tm_pub_service"
./discovery_wrapper \
--discovery_server 10.0.2.15:11080 \
--wrapper_config '{"before_waitfor_keys": [{"name":"bc2/parameter_publisher_proxy/"}], "cmd_line_name_keys": [{"parameter":"--sdbservice", "name":"bc2/asset_manager/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/tm_pub_service/SV030/50/10.0.2.15:11700"}]}' \
/usr/bin/jemalloc.sh ~/bc2/usr/bin/tm_pub_service &

echo "starting to_redis for SV030"
./discovery_wrapper \
--discovery_server 10.0.2.15:11080 \
--wrapper_config '{"cmd_line_name_keys": [{"parameter":"--tlmsource", "name":"bc2/telemetry_distributor_proxy/"}, {"parameter":"--redis", "name":"bc2/redis/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/tm_to_redis/SV030/10.0.2.15:1"}]}' \
/usr/bin/jemalloc.sh ~/bc2/usr/bin/to_redis --redis_password 1234abcd --assets SV030 &

echo "starting to_redis for O3b_F01"
./discovery_wrapper \
--discovery_server 10.0.2.15:11080 \
--wrapper_config '{"cmd_line_name_keys": [{"parameter":"--tlmsource", "name":"bc2/telemetry_distributor_proxy/"}, {"parameter":"--redis", "name":"bc2/redis/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/tm_to_redis/O3b_F01/10.0.2.15:1"}]}' \
/usr/bin/jemalloc.sh ~/bc2/usr/bin/to_redis --redis_password 1234abcd --assets O3b_F01 &

echo "starting stream gateway for SV030"
./discovery_wrapper \
--discovery_server 10.0.2.15:11080 \
--wrapper_config '{"before_waitfor_keys": [{"name":"bc2/parameter_publisher_proxy/"}], "cmd_line_name_keys": [{"parameter":"--evtsource", "name":"bc2/event_distributor_proxy/"}, {"parameter":"--sdbservice", "name":"bc2/asset_manager/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/stream_gateway/SV030/10.0.2.15:11550"}] }' \
/usr/bin/jemalloc.sh ~/bc2/usr/bin/rawtcp_altair_gateway --name streamgateway --gateway_id "sv030-int-1" --tmassets SV030 30 --tcassets SV030 30 --gep mss_sim_sv030 --tc_listen_hostport 0.0.0.0:11550 --max_tm_framecount 4095 --link_publish_interval_seconds 600 --log_console

echo "starting simple ack gateway for O3b_F01"
./discovery_wrapper \
--discovery_server 10.0.2.15:11080 \
--wrapper_config '{"before_waitfor_keys": [{"name":"bc2/parameter_publisher_proxy/"}], "cmd_line_name_keys": [{"parameter":"--evtsource", "name":"bc2/event_distributor_proxy/"}, {"parameter":"--sdbservice", "name":"bc2/asset_manager/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/stream_gateway/O3b_F01/10.0.2.15:11551"}] }' \
/usr/bin/jemalloc.sh ~/bc2/usr/bin/simple_ack_gateway  --gateway_id "o3b_f01-int-1" --tcassets O3b_F01 55 --tc_listen_hostport 0.0.0.0:11551 &

# echo "starting to_mq"
# ./discovery_wrapper \
# --discovery_server 10.0.2.15:11080 \
# --wrapper_config '{"cmd_line_name_keys": [{"parameter":"--tlmsource", "name":"bc2/telemetry_distributor_proxy/"}, {"parameter":"--mq_broker", "name":"aga/activemq_broker/", "use_all_up": false, "split_host_port":true } ], "running_keys_up": [{"name":"bc2/tm_to_mq/10.0.2.15:1"}] }' \
# /usr/bin/jemalloc.sh ~/bc2/usr/bin/to_mq &



# echo "starting to_mq"
# ./discovery_wrapper \
# --discovery_server 10.0.2.15:11080 \
# --wrapper_config {"cmd_line_name_keys": [{"parameter":"--tlmsource", "name":"bc2/telemetry_distributor_proxy/"}, {"parameter":"--mq_broker", "name":"aga/activemq_broker/", "use_all_up": false, "split_host_port":true } ], "running_keys_up": [{"name":"bc2/tm_to_mq/10.0.2.15:1"}] } \
# /usr/bin/jemalloc.sh ~/bc2/usr/bin/to_mq &

echo "need to manually start tcservice"
