#!/bin/bash

ntckit_inst_versions=$(git ls-remote --heads --tags https://github.com/NextThingCo/CHIP-linux.git)
echo "Debian Based Versions Found In Stable"
while read -r line; do
    if [[ $line == *"refs/heads/debian"* ]]
    then
        echo "${line##*/}"
    fi
done <<< "$ntckit_inst_versions"
