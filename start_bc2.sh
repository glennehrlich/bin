#!/usr/bin/env bash

# ============================================================
# Some environment variables you might want to change:
# ============================================================

# This is the top of the bc2 runtree. Commonly it is ~/bc2.
BC2=~/bc2

# These are for setting up various assets.
SETUP_SV030=true
SETUP_O3b_F01=true

# This is the version of the etcd docker container that is retrieved
# from artifactory. The right version to use can be found on
# https://confluence-sdteob.web.boeing.com/display/BC2/Running+services+for+dev+testing.
ETCD_VERSION=3.5.9-R6

# This is the version of redis docker container that is retrieved from
# artifactory. The right version to use can be found on
# https://confluence-sdteob.web.boeing.com/display/BC2/Running+services+for+dev+testing.
REDIS_VERSION=0.8.0-DEV

# The ip address of your local vm. Normally the first variant
# automatically retrieves it with the hostname, but if that does not
# work, then uncomment the 2nd form and put in the correct value.
IP=$(hostname -I | awk '{print $1}')
# IP_ADDRESS=10.0.2.15

# These are the settings for the O3b_F01 sim that int-1 uses.
GSS_O3b_F01_SIM_HOSTNAME=gssl0.es.bss.boeing.com
GSS_O3b_F01_SIM_PORT_TM=3072
GSS_O3b_F01_SIM_PORT_TC=3022

# Set this whether you like sdbservice starting cold or warm.
# It is recommended to start sdbservice cold.
# SDBSERVICE_START_COLD=false
SDBSERVICE_START_COLD=true

# Clear redis keys.
#
# Clears the redis keys after starting the redis docker container but
# before starting anything else.
#
# DANGEROUS: you may want to leave this disabled,
# but during development it is very convenient not to have stale or
# obsolete keys in your redis database.
#
# Requires redis-cli:
# sudo apt-get update
# sudo apt install redis-tools
# CLEAR_REDIS_KEYS=false
CLEAR_REDIS_KEYS=true

echo
echo '------------------------------------------------------------'
echo
echo 'ENVIRONMENT VARS'
echo
echo "BC2=${BC2}"
echo "SETUP_SV030=${SETUP_SV030}"
echo "SETUP_O3b_F01=${SETUP_O3b_F01}"
echo "ETCD_VERSION=${ETCD_VERSION}"
echo "REDIS_VERSION=${REDIS_VERSION}"
echo "IP=${IP}"

if [[ "${SETUP_O3b_F01}" == "true" ]]; then
    echo "GSS_O3b_F01_SIM_HOSTNAME=${GSS_O3b_F01_SIM_HOSTNAME}"
    echo "GSS_O3b_F01_SIM_PORT_TM=${GSS_O3b_F01_SIM_PORT_TM}"
    echo "GSS_O3b_F01_SIM_PORT_TC=${GSS_O3b_F01_SIM_PORT_TC}"
fi

echo "SDBSERVICE_START_COLD=${SDBSERVICE_START_COLD}"
echo "CLEAR_REDIS_KEYS=${CLEAR_REDIS_KEYS}"
echo

# ============================================================
# Functions
# ============================================================

# asset_active ASSET
#
# Determine if an asset is active.
# Return 0 (success) only if asset is active.
# Return 1 if not found or if it does not return a response (indicating database loaded but not active).
function asset_active {
    local asset=$1

    response=$(curl -X GET -s --header 'Accept: application/json' "http://${IP}:11505/getactiveversion?asset=${asset}")

    if [[ "$response" == *"not found"* ]]; then
        return 1
    elif [[ -n  "$response" ]]; then
        return 0
    else
        return 1
    fi
}


# load_database ASSET CATEGORY TYPE XTCE
#
# Use loaddatabase to load and activate a database file.
function load_database {
    local asset=$1
    local category=$2
    local type=$3
    local xtce=$4

    local xtce_file=${BC2}/usr/etc/${xtce}

    if [[ ! -f $xtce_file ]]; then
        echo "xtce file ${xtce_file} not found, find file in /home1/tn725c/xtce and copy to ${BC2}/usr/etc"
        exit 1
    fi

    if ! ${BC2}/usr/bin/loaddatabase -a $asset -c $category -t $type --activate -x $xtce_file; then
        echo "could not load database file $xtce_file"
        exit 1
    fi

    echo "successfully loaded and activated asset $asset with $xtce_file"
}


# test_and_load_database ASSET CATEGORY TYPE XTCE
#
# Test if an asset is active, if not, then load and activate it's xtce.
function test_and_load_database {
    local asset=$1
    local category=$2
    local type=$3
    local xtce=$4

    if ! asset_active $asset; then
        echo "asset $asset is not active, loading and activating $xtce"
        load_database $asset $category $type $xtce
    else
        echo "asset $asset is already active"
    fi
}


function initialize {
    echo '------------------------------------------------------------'
    echo

    echo "clearing logs"
    rm -f $BC2/usr/log/*

    echo "clearing sdbservice lock file"
    rm -f $BC2/usr/data/sdb/xtce/.sdbservice_lock
    echo
}


function start_etcd {
    echo '------------------------------------------------------------'
    echo
    echo "starting etcd"
    echo

    mkdir -p ${BC2}/usr/data/etcd
    chmod 777 ${BC2}/usr/data/etcd

    docker pull aga-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/bc2/etcd-server:${ETCD_VERSION}

    docker run \
           --name etcd-server \
           --detach --tty --rm --publish 11080:11080 \
           --entrypoint \
           /usr/bin/delay_shutdown.bash \
           aga-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/bc2/etcd-server:${ETCD_VERSION} \
           30 \
           /usr/bin/etcd \
           --name discovery1 \
           --data-dir /etcd-data \
           --listen-client-urls http://0.0.0.0:11080 \
           --advertise-client-urls http://0.0.0.0:11080 \
           --listen-peer-urls http://0.0.0.0:11081 \
           --initial-advertise-peer-urls http://0.0.0.0:11081 \
           --initial-cluster discovery1=http://0.0.0.0:11081 \
           --initial-cluster-token aga-disco-tkn \
           --initial-cluster-state new \
           --log-level info \
           --logger zap \
           --log-outputs stderr

    sleep 5
    echo
}


function start_redis {
    echo '------------------------------------------------------------'
    echo
    echo "starting redis"
    echo

    chmod a+rw ${BC2}

    docker pull aga-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/bc2/bc2-redis/aga_redis_server:${REDIS_VERSION}

    docker run \
           --name redis \
           --detach --tty --rm --publish 11500:11500 \
           -v ${BC2}:/usr/data/storage \
           --entrypoint /usr/bin/discovery_wrapper \
           aga-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/bc2/bc2-redis/aga_redis_server:${REDIS_VERSION} \
           --discovery_server ${IP}:11080 \
           --wrapper_config '{"shutdown_grace_seconds": 60, "running_ports":[11500], "running_keys_up": [{"name":"bc2/redis/'"${IP}"':11500"}] }' \
           redis-server /usr/data/redis.conf \
           --dir /usr/data/storage

    sleep 5

    if [[ "$CLEAR_REDIS_KEYS" == "true" ]]; then
        if command -v redis-cli &> /dev/null; then
            echo
            echo "deleting redis keys"
            echo
            redis-cli --pass 1234abcd -p 11500 FLUSHALL &> /dev/null
        else
            echo
            echo "in the script, CLEAR_REDIS_KEYS is true but redis-cli not found; exiting script"
            exit 1
        fi
    fi
}


function start_tc_status_and_event_proxy {
    echo '------------------------------------------------------------'
    echo
    echo "starting tc status and event proxy"
    echo

    ${BC2}/usr/bin/discovery_wrapper \
          --wrapper_config \
          '{"running_keys_down": [{"name":"bc2/event_publisher_proxy/500/'"${IP}"':11600"}, {"name":"bc2/event_distributor_proxy/500/'"${IP}"':11601"}] }' \
          ${BC2}/usr/bin/message_distributor_proxy \
          --discovery_server ${IP}:11080 \
          --upstream_port 11600 \
          --downstream_port 11601 \
          -q 500 \
          --event &
}


function start_tm_proxy {
    echo '------------------------------------------------------------'
    echo
    echo "starting tm proxy"
    echo

    ${BC2}/usr/bin/discovery_wrapper \
          --wrapper_config \
          '{"running_keys_down": [{"name":"bc2/parameter_publisher_proxy/500/'"${IP}"':11620"}, {"name":"bc2/telemetry_distributor_proxy/500/'"${IP}"':11621"}] }' \
          ${BC2}/usr/bin/message_distributor_proxy \
          --discovery_server ${IP}:11080 \
          --upstream_port 11620 \
          --downstream_port 11621 \
          -q 500 &

    sleep 5
}


function start_sdbservice {
    echo '------------------------------------------------------------'
    echo
    echo "starting sdbservice"
    echo

    # Set --cold if set in env var section at top of script.
    SDBSERVICE_OPTIONS="--no_unique_name --no_unsupported_encoding"
    if [[ "$SDBSERVICE_START_COLD" == "true" ]]; then
        echo "starting sdbservice cold"
        SDBSERVICE_OPTIONS="${SDBSERVICE_OPTIONS} --cold"
    else
        echo "starting sdbservice warm"
    fi
    echo
    echo "SDBSERVICE_OPTIONS=${SDBSERVICE_OPTIONS}"
    echo

    ${BC2}/usr/bin/discovery_wrapper \
          --discovery_server ${IP}:11080 \
          --wrapper_config '{"shutdown_grace_seconds": 60, "before_waitfor_keys": [{"name": "bc2/event_publisher_proxy/"}], "running_ports":[11505], "running_keys_up": [{"name":"bc2/asset_manager/'"${IP}"':11505"}]}' \
          /usr/bin/jemalloc.sh ${BC2}/usr/bin/sdbservice ${SDBSERVICE_OPTIONS} &

    if [[ "$SDBSERVICE_START_COLD" == "true" ]]; then
        sleep 5
    else
        # Give extra time for loading warm for sdbservice to load it's
        # persistence files.
        sleep 15
    fi
}


function start_parameter_manager {
    echo '------------------------------------------------------------'
    echo
    echo "starting parameter manager"
    echo

    ${BC2}/usr/bin/discovery_wrapper \
          --discovery_server ${IP}:11080 \
          --wrapper_config '{"cmd_line_name_keys": [{"parameter":"--evtsource", "name":"bc2/event_distributor_proxy/"}, {"parameter":"--sdbservice", "name":"bc2/asset_manager/", "use_all_up": false, "split_host_port":true}, {"parameter":"--redis", "name":"bc2/redis/", "use_all_up": false, "split_host_port":true} ], "running_ports":[11510], "running_keys_up": [{"name":"bc2/parameter_manager_service/'"${IP}"':11510"}]}' \
          /usr/bin/jemalloc.sh ${BC2}/usr/bin/parameter_manager_service --redis_password 1234abcd &

    sleep 5
}


function start_tcservice {
    echo '------------------------------------------------------------'
    echo
    echo "starting tcservice"
    echo

    ${BC2}/usr/bin/discovery_wrapper \
          --discovery_server ${IP}:11080 \
          --wrapper_config '{"shutdown_grace_seconds": 60, "before_waitfor_keys": [{"name": "bc2/event_publisher_proxy/"}], "cmd_line_name_keys": [{"parameter":"--evtsource", "name":"bc2/event_distributor_proxy/"}, {"parameter":"--parameter_manager", "name":"bc2/parameter_manager_service/", "use_all_up": false, "split_host_port":true}, {"parameter":"--sdbservice", "name":"bc2/asset_manager/", "use_all_up": false, "split_host_port":true} ], "running_ports":[11520], "running_keys_up": [{"name":"bc2/tcservice/'"${IP}"':11520"}]}' \
          /usr/bin/jemalloc.sh ${BC2}/usr/bin/tcservice &

    sleep 5
}


function start_SV030 {
    echo '------------------------------------------------------------'
    echo
    echo "starting SV030"
    echo

    echo "starting SV030 mss sim"
    echo

    docker run \
           --name mss_sim_sv030 \
           --detach --tty --rm \
           --publish 32000:32000 \
           --publish 32100:32100 \
           bc2-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/mss/palermo/sw_sim_docker_image:boeing_ground_dist_2

    sleep 5
    echo

    echo '------------------------------------------------------------'
    echo
    echo "starting to_redis for sv030-int-1 (SV030 stream gateway)"
    echo

    ${BC2}/usr/bin/discovery_wrapper \
          --discovery_server ${IP}:11080 \
          --wrapper_config '{"shutdown_grace_seconds": 30, "cmd_line_name_keys": [{"parameter":"--tlmsource", "name":"bc2/telemetry_distributor_proxy/"}, {"parameter":"--redis", "name":"bc2/redis/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/tm_to_redis/sv030-int-1/'"${IP}"':1"}]}' \
          /usr/bin/jemalloc.sh ${BC2}/usr/bin/to_redis --redis_password 1234abcd --assets sv030-int-1 &

    echo '------------------------------------------------------------'
    echo
    echo "starting tm publisher for SV030"
    echo

    echo "doing setup"
    echo

    ${BC2}/usr/bin/add_rawtcp_gep_asset.sh mss_sim_sv030 ${IP} 32100 32000
    ${BC2}/usr/bin/set_parameter -a mss_sim_sv030 -p bc2_prop_tm_max_ground_frame -v 512
    ${BC2}/usr/bin/add_assets -a sv030-int-1 -c service -t streamgateway

    echo
    echo "starting up tm publisher"
    echo

    ${BC2}/usr/bin/discovery_wrapper \
          --discovery_server ${IP}:11080 \
          --wrapper_config '{"before_waitfor_keys": [{"name":"bc2/parameter_publisher_proxy/"}], "cmd_line_name_keys": [{"parameter":"--sdbservice", "name":"bc2/asset_manager/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/tm_pub_service/SV030/50/'"${IP}"':11700"}]}' \
          /usr/bin/jemalloc.sh ${BC2}/usr/bin/tm_pub_service &

    sleep 5

    echo '------------------------------------------------------------'
    echo
    echo "starting to_redis for SV030"
    echo

    ${BC2}/usr/bin/discovery_wrapper \
          --discovery_server ${IP}:11080 \
          --wrapper_config '{"cmd_line_name_keys": [{"parameter":"--tlmsource", "name":"bc2/telemetry_distributor_proxy/"}, {"parameter":"--redis", "name":"bc2/redis/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/tm_to_redis/SV030/'"${IP}"':1"}]}' \
          /usr/bin/jemalloc.sh ${BC2}/usr/bin/to_redis --redis_password 1234abcd --assets SV030 &

    sleep 5

    echo '------------------------------------------------------------'
    echo
    echo "starting stream gateway for SV030"
    echo

    test_and_load_database SV030 spacecraft MSS SV030_7.0-constraint.xml

    ${BC2}/usr/bin/discovery_wrapper \
          --discovery_server ${IP}:11080 \
          --wrapper_config '{"before_waitfor_keys": [{"name":"bc2/parameter_publisher_proxy/"}], "cmd_line_name_keys": [{"parameter":"--evtsource", "name":"bc2/event_distributor_proxy/"}, {"parameter":"--sdbservice", "name":"bc2/asset_manager/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/stream_gateway/SV030/'"${IP}"':11550"}] }' \
          /usr/bin/jemalloc.sh ${BC2}/usr/bin/rawtcp_altair_gateway \
          --name streamgateway \
          --gateway_id "sv030-int-1" \
          --tmassets SV030 30 \
          --tcassets SV030 30 \
          --gep mss_sim_sv030 \
          --tc_listen_hostport 0.0.0.0:11550 \
          --max_tm_framecount 4095 \
          --link_publish_interval_seconds 600 &

    echo
}


function start_O3b_F01 {
    echo '------------------------------------------------------------'
    echo
    echo "starting O3b_F01"
    echo

    echo '------------------------------------------------------------'
    echo
    echo "starting to_redis for cortex-int-1 (O3b_F01 stream gateway)"
    echo

    ${BC2}/usr/bin/discovery_wrapper \
          --discovery_server ${IP}:11080 \
          --wrapper_config '{"shutdown_grace_seconds": 30, "cmd_line_name_keys": [{"parameter":"--tlmsource", "name":"bc2/telemetry_distributor_proxy/"}, {"parameter":"--redis", "name":"bc2/redis/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/tm_to_redis/cortex-int-1/'"${IP}"':1"}]}' \
          /usr/bin/jemalloc.sh ${BC2}/usr/bin/to_redis --redis_password 1234abcd --assets cortex-int-1 &

    echo '------------------------------------------------------------'
    echo
    echo "starting tm publisher for O3b_F01"
    echo

    echo "doing setup"
    echo

    ${BC2}/usr/bin/add_cortex_gep_asset.sh cortex_sim_O3b_F01 ${GSS_O3b_F01_SIM_HOSTNAME} ${GSS_O3b_F01_SIM_PORT_TM} ${GSS_O3b_F01_SIM_PORT_TC}
    ${BC2}/usr/bin/set_parameter -a cortex_sim_O3b_F01 -p bc2_prop_tm_max_ground_frame -v 612
    ${BC2}/usr/bin/add_assets -a cortex-int-1 -c service -t streamgateway

    echo
    echo "starting up tm publisher"
    echo

    ${BC2}/usr/bin/discovery_wrapper \
          --discovery_server ${IP}:11080 \
          --wrapper_config '{"shutdown_grace_seconds": 30, "before_waitfor_keys": [{"name":"bc2/parameter_publisher_proxy/"}], "cmd_line_name_keys": [{"parameter":"--sdbservice", "name":"bc2/asset_manager/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/tm_pub_service/O3b_F01/50/'"${IP}"':11710"}]}' \
          /usr/bin/jemalloc.sh ${BC2}/usr/bin/tm_pub_service -n tm_pub_service702 &

    sleep 5

    echo '------------------------------------------------------------'
    echo
    echo "starting to_redis for O3b_F01"
    echo

    ${BC2}/usr/bin/discovery_wrapper \
          --discovery_server ${IP}:11080 \
          --wrapper_config '{"shutdown_grace_seconds": 30, "cmd_line_name_keys": [{"parameter":"--tlmsource", "name":"bc2/telemetry_distributor_proxy/"}, {"parameter":"--redis", "name":"bc2/redis/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/tm_to_redis/O3b_F01/'"${IP}"':1"}]}' \
          /usr/bin/jemalloc.sh ${BC2}/usr/bin/to_redis --redis_password 1234abcd --assets O3b_F01 &

    sleep 5

    echo '------------------------------------------------------------'
    echo
    echo "starting stream gateway for O3b_F01"
    echo

    test_and_load_database O3b_F01 spacecraft 702DA O3b_F01_3.2.xml

    ${BC2}/usr/bin/discovery_wrapper \
          --discovery_server ${IP}:11080 \
          --wrapper_config '{"shutdown_grace_seconds": 30, "before_waitfor_keys": [{"name":"bc2/parameter_publisher_proxy/"}], "cmd_line_name_keys": [{"parameter":"--evtsource", "name":"bc2/event_distributor_proxy/"}, {"parameter":"--sdbservice", "name":"bc2/asset_manager/", "use_all_up": false, "split_host_port":true}], "running_keys_up": [{"name":"bc2/stream_gateway/O3b_F01/'"${IP}"':11551"}] }' \
          /usr/bin/jemalloc.sh ${BC2}/usr/bin/cortex_702da_gateway \
          --name streamgateway702 \
          --gateway_id cortex-int-1 \
          --tmassets O3b_F01 55 \
          --tcassets O3b_F01 55 \
          --gep cortex_sim_O3b_F01 \
          --tc_listen_hostport 0.0.0.0:11551 \
          --link_publish_interval_seconds 600 &

    echo
}


# ============================================================
# The script processing begins here.
# ============================================================

initialize

start_etcd

start_redis

start_tc_status_and_event_proxy

start_tm_proxy

start_sdbservice

start_parameter_manager

start_tcservice

if [[ "${SETUP_SV030}" == "true" ]]; then
    start_SV030
fi

if [[ "${SETUP_O3b_F01}" == "true" ]]; then
    start_O3b_F01
fi

exit 0
