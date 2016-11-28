#!/bin/bash
# Variables that are used during this script (Config.cfg will also import more)
ntckit_inst_continue=true
ntckit_inst_name="NTC-Kit"
ntckit_inst_installed=false
ntckit_inst_status="Not Complete"
ntckit_inst_summary="Waiting to update system and install required packages"
ntckit_inst_udevfile="/etc/udev/rules.d/99-allwinner.rules"

# These are the default required packages, this may get extended below depending on requirements
var_pack="u-boot-tools android-tools-fastboot git build-essential curl android-tools-fsutils libusb-1.0-0-dev pkg-config libncurses5-dev bc"
var_pack="$var_pack mercurial cmake unzip device-tree-compiler libncurses-dev cu linux-image-extra-virtual python-dev python-pip g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf pkg-config"
if uname -a |grep -q 64; then
  var_pack="$var_pack libc6-i386 lib32stdc++6 lib32z1 libusb-1.0-0:i386"
fi



# Check that script is not being run as sudo
if [ ! "$EUID" -ne 0 ]; then
    echo
    echo " - Install.sh must be run as a normal user, do not use sudoor exit back to your normal user from root"
    echo " - You will be prompted for your password as required depending how quick this install runs"
    echo
    exit 1
fi


echo
echo
echo
echo "------------------------------------------------------------------------"
echo "       $ntckit_inst_name - Installation Script"
echo "------------------------------------------------------------------------"


# STEP 1 - Load Config.cfg and verify it looks correct
echo
echo  -e "         \033[0;32mStep 01:\033[0m Loading Local Configuration File"
if [ ! -f Config.cfg ]; then
    ntckit_inst_status="Not Complete - Unable to locate Config.cfg"
    ntckit_inst_summary="Unable to locate Config.cfg, make sure you are executing Install.sh in the directory that it exists in"
    ntckit_inst_continue=false
else
    echo "                   - Found Config.cfg , Checking if settings are valid"
    source Config.cfg
    echo  "                  - Config.cfg has been verified"
fi




# STEP 2 - Perform update and installation of packages
if [ "$ntckit_inst_continue" = true ]; then
    echo
    echo  -e "         \033[0;32mStep 02:\033[0m Perform APT-GET & APT-GET INSTALL"
    echo  "                  You may be prompted for your password to allow sudo for this step"
    if [ "$ntckit_sys_update" = true ]; then
        sudo apt-get -y update
    else
        echo  "                  NOTE = apt-get update skipped as per Config.cfg->ntckit_sys_update setting"
    fi
    echo
    sudo apt-get -y install $var_pack
fi



# STEP 3 - Add user to required groups
if [ "$ntckit_inst_continue" = true ]; then
    echo
    echo  -e "         \033[0;32mStep 03:\033[0m Adding user to dialout & plugdev groups"
    echo  "                  You may be prompted for your password to allow sudo for this step"
    echo
    sudo usermod -a -G dialout $(logname)
    sudo usermod -a -G plugdev $(logname)
    echo  "                  - User has been added to dialout & plugdev groups"
fi



# STEP 4 - Create udev entry for USB Driver
if [ "$ntckit_inst_continue" = true ]; then
    echo
    echo  -e "         \033[0;32mStep 04:\033[0m Create udev entry for USB Driver & Reload Rules"
    echo  "                  You may be prompted for your password to allow sudo for this step"
    echo
    if [[ -f "$ntckit_inst_udevfile" ]]; then
        echo  "                  - $ntckit_inst_udevfile has been deleted so it can be regenerated"
    	sudo rm "$ntckit_inst_udevfile"
    fi
    echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1f3a", ATTRS{idProduct}=="efe8", GROUP="plugdev", MODE="0660" SYMLINK+="usb-chip"' | sudo tee -a "$ntckit_inst_udevfile"
    echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="1010", GROUP="plugdev", MODE="0660" SYMLINK+="usb-chip-fastboot"' | sudo tee -a "$ntckit_inst_udevfile"
    echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1f3a", ATTRS{idProduct}=="1010", GROUP="plugdev", MODE="0660" SYMLINK+="usb-chip-fastboot"' | sudo tee -a "$ntckit_inst_udevfile"
    echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", GROUP="plugdev", MODE="0660" SYMLINK+="usb-serial-adapter"' | sudo tee -a "$ntckit_inst_udevfile"

    echo  "                  - $ntckit_inst_udevfile has been created"
    sudo udevadm control --reload-rules
    echo  "                  - udev rules have been reloaded"
fi

# STEP 5 - Create directories and git clone NTC- based requirements
if [ "$ntckit_inst_continue" = true ]; then
    echo
    echo  -e "         \033[0;32mStep 05:\033[0m Create local directory structure and git clone required NTC repositories"
    if [ ! -d "modules" ]; then
        mkdir "modules"
        echo  "                  - modules       Directory has been created"
    else
        echo  "                  - modules       Directory already exists"
    fi
    if [ ! -d "output" ]; then
        mkdir "output"
        echo  "                  - output        Directory has been created"
    else
        echo  "                  - output        Directory already exists"
    fi
    if [ ! -d "ready" ]; then
        mkdir "ready"
        echo  "                  - ready         Directory has been created"
    else
        echo  "                  - ready         Directory already exists"
    fi
    if [ ! -d "$ntckit_path_sunxitools" ]; then
        git clone --depth 1 http://github.com/NextThingCo/sunxi-tools "$ntckit_path_sunxitools"
        echo  "                  - sunxitools    Directory has been cloned from github"
    else
        cd "$ntckit_path_sunxitools"
        git pull
        cd ".."
        echo  "                  - sunxitools    Directory has been updated from github"
    fi

	pushd "$ntckit_path_sunxitools"
	make
	if [[ -L /usr/local/bin/fel ]]; then
		sudo rm /usr/local/bin/fel
	fi
	sudo ln -s $PWD/fel /usr/local/bin/fel
	popd

    if [ ! -d "tools" ]; then
        git clone --depth 1 http://github.com/NextThingCo/CHIP-tools tools
        echo  "                  - tools         Directory has been cloned from github"
    else
        cd "tools"
        git pull
        cd ".."
        echo  "                  - tools         Directory has been updated from github"
    fi
    if [ ! -d "buildroot" ]; then
        git clone --depth 1 http://github.com/NextThingCo/CHIP-buildroot buildroot
        echo  "                  - buildroot     Directory has been cloned from github"
    else
        cd "buildroot"
        git pull
        cd ".."
        echo  "                  - buildroot     Directory has been updated from github"
    fi

    if [ "$ntckit_inst_osget" = true ]; then
        if [ ! -d "linux" ]; then
            git clone --single-branch --branch "debian/$ntckit_kernel$ntckit_suffix" --depth 1 https://github.com/NextThingCo/CHIP-linux.git linux
            echo  "                  - linux         Directory has been cloned from github - $ntckit_kernel$ntckit_suffix"
        else
            cd "linux"
            git pull
            cd ".."
            echo  "                  - linux         Directory has been updated from github"
        fi
    fi
    ntckit_inst_status="Complete"
    ntckit_inst_summary="The script has completed, now you can configure Config.cfg or start Build.sh"
fi


echo
echo -e "\033[0;32m     $ntckit_inst_name Installation Status:\033[0m $ntckit_inst_status"
echo -e "\033[0;32m    $ntckit_inst_name Installation Summary:\033[0m $ntckit_inst_summary"
echo
