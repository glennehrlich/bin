#!/usr/bin/env bash

host=127.0.0.1
port=11505

asset=SV030
version=7-0

curl -X PUT -s --header 'Accept: application/json' "http://localhost:$port/setdatabaseactive?asset=$asset&version=$version"
echo
echo


