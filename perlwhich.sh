#!/bin/bash
perl  -e 'print join "\n", @INC' | xargs -n 1 -i find {} -type f -name $1
