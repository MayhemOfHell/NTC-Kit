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



ntckit_inst_versions=$(git ls-remote --heads --tags https://github.com/NextThingCo/CHIP-linux.git)

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="NTC-Kit - CHIP Kernel Build & Flasher"
TITLE="Select A Known Version"
MENU="Please select one of the available kernel version below to download and build"
ICOUNTER=1
ICOUNTERA=1
OPTIONSAAA=()
while read -r line; do
    if [[ $line == *"refs/heads/debian"* ]]
    then
        OPTIONSAAA[$ICOUNTER]="$ICOUNTERA"
        ICOUNTER=$(($ICOUNTER + 1))
        OPTIONSAAA[$ICOUNTER]="${line##*/}"
        ICOUNTER=$(($ICOUNTER + 1))
        ICOUNTERA=$(($ICOUNTERA + 1))
    fi
done <<< "$ntckit_inst_versions"   

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONSAAA[@]}" \
                2>&1 >/dev/tty)

CHOICEVAL=$(($CHOICE * 2))
case $CHOICE in
        1)
            echo "You chose Option 1 = ${OPTIONSAAA[$CHOICEVAL]}"
            cfgChangeValue "buildroot_orig/.config" "BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION" "\"debian/${OPTIONSAAA[$CHOICEVAL]}"\"
            cfgChangeValue "buildroot_orig/.config" "BR2_LINUX_KERNEL_VERSION" "\"debian/${OPTIONSAAA[$CHOICEVAL]}"\"
            ;;
        2)
            echo "You chose Option 2 = ${OPTIONSAAA[$CHOICEVAL]}"
            cfgChangeValue "buildroot_orig/.config" "BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION" "\"debian/${OPTIONSAAA[$CHOICEVAL]}"\"
            cfgChangeValue "buildroot_orig/.config" "BR2_LINUX_KERNEL_VERSION" "\"debian/${OPTIONSAAA[$CHOICEVAL]}"\"
            ;;
        3)
            echo "You chose Option 3"
            ;;
esac
