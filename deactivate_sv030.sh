#!/usr/bin/env bash

port=11505

asset=SV030

curl -s --header 'Accept: application/json' "http://localhost:$port/setdatabaseinactive?asset=$asset"
echo
echo


