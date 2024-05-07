#!/usr/bin/env bash

host=127.0.0.1
port=11505

asset=BogusSAT

curl -x PUT-s --header 'Accept: application/json' "http://localhost:$port/setdatabaseinactive?asset=$asset"
echo
echo


