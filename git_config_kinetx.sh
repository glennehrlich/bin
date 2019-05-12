#!/usr/bin/env bash

if [[ ! -e .git ]]; then
    echo "error: not in a git repository directory"
    exit 1
fi

git config user.name  "Glenn Ehrlich"
git config user.email "glenn.ehrlich@kinetx.com"

exit 0
