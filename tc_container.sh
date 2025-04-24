#!/usr/bin/env bash


ASSET=$1
COMMAND=$2

curl -s --header 'Accept: application/json' "http://localhost:11505/getcontainercontents?asset=$1&name=$2&scope=tc&includeCompound=false" | jq
