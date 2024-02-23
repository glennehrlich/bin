#!/usr/bin/env bash

# Delete all of the redis keys.

redis-cli --pass 1234abcd -p 11500 KEYS "*" | xargs redis-cli --pass 1234abcd -p 11500 DEL
