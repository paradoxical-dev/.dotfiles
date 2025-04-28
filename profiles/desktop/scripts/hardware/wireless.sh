#!/bin/bash

#----------- initial warning
inform_msg "WARNING" "It is highly recommended to add the 'networkmanager' USE flag globally to allow other networkmanager in other packages"
sleep 3

# TODO: add flags
#----------- define available USE flags
flags=(
    "concheck"
    "gtk-doc"
    "introspection"
    "modemmanager"
    "nss"
    "ppp"
    "tools"
    "wext"
    "wifi"
    "audit"
    "bluetooth"
    "connection-sharing"
    "debug"
    "dhclient"
    "dhcpcd"
    "elogind"
    "gnutls"
    "iptables"
    "iwd"
    "libedit"
    "nftables"
    "ofono"
    "ovs"
    "policykit"
    "psl"
    "resolvconf"
    "selinux"
    "syslog"
    "systemd"
    "teamd"
    "test"
    "vala"
)

#----------- handle USE flag modifications
gum_confirm "Would you like to edit the USE flags for networkmanager?"
update_use=$?
echo -e "\n"

if [ $update_use -eq 0 ]; then
   echo -e "${cyan}Here is your current global USE flags for reference:${color_end}" 
   emerge --info | grep ^USE=
   echo -e "\n"
   edit_use "networkmanager" "net-misc/networkmanager" "${flags[@]}"
else
    echo -e "Skipping USE modifications..."
    echo -e "\n"
fi

sudo emerge --ask "net-misc/networkmanager"
echo -e "\n"

#----------- check for and remove dhcpcd
if $pkg_exists dhcpcd; then
   echo "dhcpcd package found. Removing from default rc-service list" 
   rc-service del dhcpcd default
   echo -e "\n"
fi

add_service "NetworkManager"

echo -e "${green}networkmanager successfully installed!${color_end}"
