#!/usr/bin/env bash

host=127.0.0.1
port=11505

asset=SV030

curl -X PUT -s --header 'Accept: application/json' "http://$host:$port/setdatabaseinactive?asset=$asset"
echo
echo
