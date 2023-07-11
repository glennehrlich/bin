#!/usr/bin/env bash

port=11505

asset=O3b_F01
version=0.1654-0

curl -s --header 'Accept: application/json' "http://localhost:$port/setdatabaseactive?asset=$asset&version=$version"
echo
echo


