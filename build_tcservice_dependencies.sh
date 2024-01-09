#!/usr/bin/env bash

# Script for building minimal services and executables for testing
# tcservice.

BC2_REPOS_TOP=~/git/bc2
BC2_RUNTREE_TOP=~/bc2

function build_executable
{
    local repo=$1
    local executable=$2

    echo
    echo "============================================================"
    echo "building $repo $executable"
    echo

    cd $BC2_REPOS_TOP/$repo/build
    if ! make $executable; then
        echo "error: could not build $repo $executable"
        exit 1
    fi

    cp bin/$executable $BC2_RUNTREE_TOP/usr/bin
}

# Kill any services we will be building and installing.
pkill -f rawtcp_altair
pkill -f to_redis
pkill -f tm_pub_service
pkill -f parameter
pkill -f sdbservice
pkill -f message
docker kill redis
docker kill etcd-server

# glenn: normal version
REPOS=(            \
  discoveryservice \
  messaging        \
  parametermanager \
  sdbservice       \
  streamgateway    \
  tcservice        \
  tmservice        \
)

# glenn: ad hoc version
# REPOS=(            \
#   sdbservice       \
# )

# For each repo, make sure it's clean, checkout master, then do a pull.
for repo in ${REPOS[@]}; do
    current_repo=$BC2_REPOS_TOP/$repo

    echo
    echo "============================================================"
    echo "doing $current_repo"
    echo
    
    cd $current_repo

    # Make sure repo is clean.
    if ! git status --porcelain ; then
        echo "error: repo $current_repo is not clean"
        exit 1
    fi

    # Checkout master.
    if ! git checkout master ; then
        echo "error: could not checkout master for $current_repo"
        exit 1
    fi
    
    # Pull master to get latest changes.
    if ! git pull origin master ; then
        echo "error: could not do git pull origin master for $current_repo"
        exit 1
    fi

    # Make the build directory and do cmake.
    rm -rf $current_repo/build
    mkdir -p $current_repo/build
    cd $current_repo/build
    if ! cmake .. ; then
        echo "error: could not do cmake in $current_repo"
        exit 1
    fi
done

# Build the services.
build_executable discoveryservice discovery_wrapper
build_executable messaging        message_distributor_proxy
build_executable parametermanager parameter_manager_service
build_executable sdbservice       sdbservice
build_executable streamgateway    rawtcp_altair_gateway
build_executable tcservice        tcservice
build_executable tmservice        tm_pub_service
build_executable tmservice        to_redis

# Build some utilities.
build_executable discoveryservice delete_discovery_key
build_executable discoveryservice get_discovery_key
build_executable discoveryservice put_discovery_key
build_executable discoveryservice view_discovery_service
build_executable messaging        tail_events
build_executable messaging        view_events
build_executable parametermanager get_parameter
build_executable parametermanager set_parameter
build_executable sdbservice       add_assets
build_executable sdbservice       get_assets
build_executable sdbservice       loaddatabase
build_executable sdbservice       tc_def
build_executable sdbservice       tm_def
build_executable sdbservice       validatextce
build_executable streamgateway    quick_altair_cmd
build_executable streamgateway    quick_boeing_sw_cmd
build_executable streamgateway    sendrawtc
build_executable tcservice        send_tc
build_executable tmservice        tail_tm
build_executable tmservice        view_tm

# Copy other things.
cp ~/git/bc2/discoveryservice/src/bc2/discovery_wrapper/*.sh $BC2_RUNTREE_TOP/usr/bin

