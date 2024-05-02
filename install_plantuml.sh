#!/usr/bin/env bash

# This must be run as sudo.
if [ "$(whoami)" != "root" ]; then
    echo "error: must run with sudo"
    exit 1
fi

PLANTUML_VERSION=1.2024.3

cd /tmp
rm -f plantuml*
curl -LO https://github.com/plantuml/plantuml/releases/download/v${PLANTUML_VERSION}/plantuml-${PLANTUML_VERSION}.jar
rm -f /usr/local/bin/plantuml*
cp plantuml*.jar /usr/local/bin
cd /usr/local/bin
ln -s plantuml-${PLANTUML_VERSION}.jar plantuml.jar





