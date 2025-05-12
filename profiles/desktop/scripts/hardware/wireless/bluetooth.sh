#!/bin/bash

if pkg_exists "bluez"; then
   echo -e "${green}bluez already installed!${color_end}" 
   exit 0
fi

flags=(
    "mesh"
    "obex"
    "readline"
    "udev"
    "btpclient"
    "cups"
    "debug"
    "deprecated"
    "doc"
    "experimental"
    "extra-tools"
    "man"
    "midi"
    "selinux"
    "systemd"
    "test"
    "test-programs"
)

#----------- handle USE flag modifications
gum_confirm "Would you like to edit the USE flags for bluez?"
update_use=$?
echo -e "\n"

sudo emerge --ask --noreplace "net-wireless/bluez"

add_service "bluetooth"
