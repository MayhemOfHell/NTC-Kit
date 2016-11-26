#!/bin/bash


# Check that script is not being run as sudo
if [ ! "$EUID" -ne 0 ]; then
    echo
    echo " - Build.sh must be run as a normal user, do not use sudoor exit back to your normal user from root"
    echo
    exit 1
fi


# STEP 1 - Load Config.cfg and verify it looks correct
if [ ! -f Config.cfg ]; then
    echo
    echo " - Unable to locate Config.cfg, make sure you are executing Build.sh in the directory that it exists in"
    echo
    exit 1
else
    source Config.cfg
fi


clear   # Clear The Screen - I hate losing my placing when searching over my console output



cd "linux"
make defconfig
#make ARCH="$ntckit_arc" "CROSS_COMPILE=$ntckit_cross" menuconfig "-j $ntckit_cores"
#make ARCH="$ntckit_arc" "CROSS_COMPILE=$ntckit_cross" "LOCALVERSION=$ntckit_suffix" "-j $ntckit_cores"
#build modules
#make ARCH="$ntckit_arc" "CROSS_COMPILE=$ntckit_cross" INSTALL_MOD_PATH=../modules
cd ".."


echo " - Build complete"
