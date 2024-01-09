#!/usr/bin/env bash

cd ~/bc2/usr/bin

echo "starting tcservice"
./discovery_wrapper \
--discovery_server 127.0.0.1:11080 \
--wrapper_config '{"before_waitfor_keys": [{"name": "bc2/event_publisher_proxy/"}], "cmd_line_name_keys": [{"parameter":"--evtsource", "name":"bc2/event_distributor_proxy/"}, {"parameter":"--parameter_manager", "name":"bc2/parameter_manager_service/", "use_all_up": false, "split_host_port":true}, {"parameter":"--sdbservice", "name":"bc2/asset_manager/", "use_all_up": false, "split_host_port":true} ], "running_ports":[11520], "running_keys_up": [{"name":"bc2/tcservice/127.0.0.1:11520"}]}' \
/usr/bin/jemalloc.sh ~/bc2/usr/bin/tcservice --log_console --log_level debug
sleep 5
