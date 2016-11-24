#!/bin/bash

clear

echo 
echo 
echo "  MayDev - Ubuntu 14.04 Setup For NTC Chip Compiling & Flashing"
echo 
echo "   - Step 1: Update Local Ubuntu  "
sudo apt-get update

echo 
echo "   - Step 2: Install required packages"
sudo apt-get install u-boot-tools android-tools-fastboot git build-essential curl android-tools-fsutils libusb-1.0-0-dev pkg-config libncurses5-dev libc6-i386 lib32stdc++6 lib32z1 libusb-1.0-0:i386


