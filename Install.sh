#!/bin/bash

clear   # Clear The Screen - I hate losing my placing when searching over my console output
# These are the default required packages, this may get extended below depending on requirements
var_pack="u-boot-tools android-tools-fastboot git build-essential curl android-tools-fsutils libusb-1.0-0-dev pkg-config libncurses5-dev"
var_pack="$var_pack mercurial cmake unzip device-tree-compiler libncurses-dev cu linux-image-extra-virtual python-dev python-pip g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf pkg-config"

echo
echo
echo "  MayDev - NTC-Kit - Linux OS Building For NTC Chip"
echo
echo "    This script will install all required packages and then also setup the basic development folder."
echo
echo "       STEP 01: Checking if running as a normal user"
if [ "$EUID" -ne 0 ]; then
  echo "             - STEP PASSED"
  echo
else
  echo "             - STEP FAILED = You are running as root.. Please execute this script as your normal user"
  echo
  exit
fi

#echo $USER
echo "       STEP 02: Detecting if running 32 or 64 bit system"
if uname -a |grep -q 64; then
  echo "             - STEP PASSED = Detected 64Bit System"
  var_pack="$var_pack libc6-i386 lib32stdc++6 lib32z1 libusb-1.0-0:i386"
else
  echo "             - STEP PASSED = Detected 32Bit System"
fi


echo
echo "       STEP 03: Installing required packages - performed as sudo, password will be prompted"
sudo apt-get -qq -y update
sudo apt-get -qq -y install $var_pack
echo "             - STEP PASSED = Packages should have been updated and installed via apt-get"
echo

echo "       STEP 04: Adding user to required groups"
sudo usermod -a -G dialout $(logname)
sudo usermod -a -G plugdev $(logname)
echo "             - STEP PASSED = User added to groups dialout & plugdev"
echo


echo "       STEP 05: Creating Device Rules (USB Driver Detection)"
#echo -e "\n Adding udev rule for Allwinner device"
#echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1f3a", ATTRS{idProduct}=="efe8", GROUP="plugdev", MODE="0660" SYMLINK+="usb-chip"
#SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="1010", GROUP="plugdev", MODE="0660" SYMLINK+="usb-chip-fastboot"
#SUBSYSTEM=="usb", ATTRS{idVendor}=="1f3a", ATTRS{idProduct}=="1010", GROUP="plugdev", MODE="0660" SYMLINK+="usb-chip-fastboot"
#SUBSYSTEM=="usb", ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", GROUP="plugdev", MODE="0660" SYMLINK+="usb-serial-adapter"
#' | sudo tee /etc/udev/rules.d/99-allwinner.rules
#sudo udevadm control --reload-rules
echo "             - STEP PASSED = udev rules file created"
echo

mkdir output
mkdir ready

echo "       STEP 06: Cloning Sunxi Tools - Required For FEL"
git clone http://github.com/NextThingCo/sunxi-tools sunxitools
#pushd sunxi-tools
#make
#if [[ -L /usr/local/bin/fel ]]; then
	#sudo rm /usr/local/bin/fel
#fi
#sudo ln -s $PWD/fel /usr/local/bin/fel
echo "             - STEP PASSED = Downloaded From GIT"
echo

echo "       STEP 07: Cloning CHIP-tools - Required for flashing"
git clone http://github.com/NextThingCo/CHIP-tools tools
echo "             - STEP PASSED = Downloaded From GIT"
echo

echo "       STEP 08: Cloning CHIP-buildroot - Required for compiling"
git clone http://github.com/NextThingCo/CHIP-buildroot buildroot
echo "             - STEP PASSED = Downloaded From GIT"
echo

echo "       STEP 09: Cloning Debian 4.4.13-ntc-mlc"
git clone --single-branch --branch debian/4.4.13-ntc-mlc --depth 1 https://github.com/NextThingCo/CHIP-linux.git linux
