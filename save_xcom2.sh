#!/bin/bash

ts=`date  "+%Y-%m-%d_%H%M%S"`

cd "/Users/glenn/Library/Application Support/Feral Interactive/XCOM 2/VFS/Local/my games/XCOM2/XComGame"

tar czvf SaveData_$ts.tgz SaveData
tar czvf CharacterPool_$ts.tgz CharacterPool
