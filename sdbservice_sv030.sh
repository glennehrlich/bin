#!/usr/bin/env bash

xtce=/home/glenn/bc2/elena/SV030_7.0.xml
asset=SV030
version=7-0

curl -s --header 'Expect:' --header 'Accept: application/json' -X POST --data-binary @$xtce "http://localhost:28460/loaddatabase?asset=$asset"
echo
echo

curl -s --header 'Accept: application/json' "http://localhost:28460/setdatabaseactive?asset=$asset&version=$version"
echo
echo


