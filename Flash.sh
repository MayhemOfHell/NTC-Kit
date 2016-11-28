#!/bin/bash

if [ ! "$EUID" -ne 0 ]; then
    echo
    echo " - Flash.sh must be run as a normal user, do not use sudoor exit back to your normal user from root"
    echo
    exit 1
fi
if [ ! -f Config.cfg ]; then
    echo
    echo " - Unable to locate Config.cfg, make sure you are executing Build.sh in the directory that it exists in"
    echo
    exit 1
else
    source Config.cfg
fi
if [ ! -f kit_functions.sh ]; then
    echo
    echo " - Unable to locate kit_functions.sh, make sure you are executing in the NTC-Kit directory only"
    echo
    exit 1
else
    source kit_functions.sh
fi

export BUILDROOT_OUTPUT_DIR="$PWD"/"$ntckit_path_buildroot"/output/ 
./tools/chip-fel-flash.sh
