#!/usr/bin/env bash

host=127.0.0.1
port=11505

asset=O3b_F01

curl -X PUT -s --header 'Accept: application/json' "http://localhost:$port/setdatabaseinactive?asset=$asset"
echo
echo
