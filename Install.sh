#!/bin/bash

clear

# These are the default required packages, this may get extended below depending on requirements
var_pack="u-boot-tools android-tools-fastboot git build-essential curl android-tools-fsutils libusb-1.0-0-dev pkg-config libncurses5-dev"

echo 
echo 
echo "  MayDev - Ubuntu 14.04 Setup For NTC Chip Compiling & Flashing"
echo 
echo "    This script will install all required packages and then also setup the basic development folder."
echo 
echo "       STEP 1: Checking if running as a normal user"
if [ "$EUID" -ne 0 ]; then
  echo "             - STEP PASSED"
  echo 
else
  echo "             - STEP FAILED = You are running as root.. Please execute this script as your normal user"
  echo 
  exit
fi

#echo $USER 
echo "       STEP 2: Detecting if running 32 or 64 bit system"
if uname -a |grep -q 64; then
  echo "             - STEP PASSED = Detected 64Bit System"
  var_pack="$var_pack libc6-i386 lib32stdc++6 lib32z1 libusb-1.0-0:i386"
else
  echo "             - STEP PASSED = Detected 32Bit System"
fi


echo 
echo "       STEP 3: Installing required packages - performed as sudo, password will be prompted"

#sudo usermod -a -G dialout $(logname)
#sudo usermod -a -G plugdev $(logname)

sudo apt-get -y update
sudo apt-get -y install $var_pack
#echo $var_pack

echo 
echo 
#sudo apt-get -y install u-boot-tools android-tools-fastboot git build-essential curl android-tools-fsutils libusb-1.0-0-dev pkg-config libncurses5-dev 



#mercurial cmake unzip device-tree-compiler libncurses-dev cu linux-image-extra-virtual python-dev python-pip g++-arm-linux-gnueabihf pkg-config
