#!/usr/bin/env bash

port=11505

asset=BogusSAT
version=1.0-0

curl -s --header 'Accept: application/json' "http://localhost:$port/setdatabaseactive?asset=$asset&version=$version"
echo
echo


