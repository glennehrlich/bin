#!/usr/bin/env bash

port=11505

xtce=/home/glenn/bc2/SV030_7.0.xml
asset=SV030
version=7-0

curl -s --header 'Expect:' --header 'Accept: application/json' -X POST --data-binary @$xtce "http://localhost:$port/loaddatabase?asset=$asset"
echo
echo

curl -s --header 'Accept: application/json' "http://localhost:$port/setdatabaseactive?asset=$asset&version=$version"
echo
echo


