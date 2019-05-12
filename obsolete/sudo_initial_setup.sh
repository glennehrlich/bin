#!/usr/bin/env bash

# This needs to be run as root or from sudo

# Remove the message of the day.
cd /etc
mv motd motd.original

# Install crucial software.
apt-get update
apt-get install emacs org-mode w3m w3m-el

# Remove goofy RAID monitor becasue it sends useless email.
apt-get remove mpt-status

