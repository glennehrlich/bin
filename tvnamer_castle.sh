#!/bin/bash

# tvnamer_castle PATTERN
# tvnamer *.mkv

pat=$1

tvnamer --series-id=83462 -m $pat
