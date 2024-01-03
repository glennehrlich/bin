#!/usr/bin/env bash

port=11505

asset=BogusSAT

curl -s --header 'Accept: application/json' "http://localhost:$port/setdatabaseinactive?asset=$asset"
echo
echo


