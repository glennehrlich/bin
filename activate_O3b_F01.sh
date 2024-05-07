#!/usr/bin/env bash

host=127.0.0.1
port=11505

asset=O3b_F01
version=0.1692-1

curl -X PUT -s --header 'Accept: application/json' "http://localhost:$port/setdatabaseactive?asset=$asset&version=$version"
echo
echo


