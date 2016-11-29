#!/bin/bash

#BR2_TARGET_GENERIC_HOSTNAME="chip"
#BR2_TARGET_GENERIC_ROOT_PASSWD="chip"
#BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION="debian/4.4.11-ntc-1"
#BR2_PACKAGE_SOMEPACKAGEHEREIGUESS
#BR2_CCACHE=y
#BR2_CCACHE_DIR="$(HOME)/.buildroot-ccache"
#BR2_CCACHE_INITIAL_SETUP=""
#BR2_CCACHE_USE_BASEDIR=y

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
if [ ! -f kit_functions.sh ]; then
    echo
    echo " - Unable to locate kit_functions.sh, make sure you are executing in the NTC-Kit directory only"
    echo
    exit 1
else
    source kit_functions.sh
fi


#cfgChangeValue "chip_defconfig" "BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION" '"debian/4.4.13-ntc-mlc-bdm"'


cd "buildroot_orig"
make "ARCH=$ntckit_arc" "CROSS_COMPILE=$ntckit_cross" -j "$ntckit_cores"
cd ".."

exit 1




# Enable Cache, Change Toolchain To Buildroot

#cd "linux"
#if [ ! -f ".config" ]; then
#    make "ARCH="$ntckit_arc "CROSS_COMPILE="$ntckit_cross "LOCALVERSION="$ntckit_suffix -j $ntckit_cores defconfig
#fi
#make menuconfig
#make "ARCH="$ntckit_arc "CROSS_COMPILE="$ntckit_cross "LOCALVERSION="$ntckit_suffix -j $ntckit_cores
#cd ".."

#toolchain type = buildroot
#http://dn.odroid.com/toolchains/



