#!/usr/bin/env bash

docker run --interactive --tty --rm --publish 32000:32000 --publish 32100:32100 bc2-docker-sandbox-sdte.artifactory-sdteob.web.boeing.com/mss/palermo/sw_sim_docker_image:boeing_ground_dist_2
