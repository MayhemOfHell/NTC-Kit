#!/bin/bash

# Check that script is not being run as sudo
if [ ! "$EUID" -ne 0 ]; then
    echo
    echo " - Build.sh must be run as a normal user, do not use sudoor exit back to your normal user from root"
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

# Enable Cache, Change Toolchain To Buildroot

cd "linux"
if [ ! -f ".config" ]; then
    make "ARCH="$ntckit_arc "CROSS_COMPILE="$ntckit_cross "LOCALVERSION="$ntckit_suffix -j $ntckit_cores defconfig
fi
#make menuconfig
#make "ARCH="$ntckit_arc "CROSS_COMPILE="$ntckit_cross "LOCALVERSION="$ntckit_suffix -j $ntckit_cores
cd ".."

cd "buildroot"
if [ ! -f ".config" ]; then
    make "chip_defconfig"
fi
make menuconfig
#toolchain type = buildroot
make
#http://dn.odroid.com/toolchains/
cd ".."



echo " - Build complete"
