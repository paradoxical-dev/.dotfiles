#!/bin/bash

if pkg_exists networkmanager; then
    echo -e "${green}networkmanager already installed${color_end}"
    exit 0
fi

#----------- initial warning
inform_msg "WARNING" "It is highly recommended to add the 'networkmanager' USE flag globally to allow other networkmanager in other packages"
sleep 2

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

#----------- check for and remove dhcpcd service
if $pkg_exists dhcpcd; then
   gum_confirm "dhcpcd package found. Remove from default service list?" 
   remove=$?
   if [[ $remove -eq 0 ]]; then
       echo "Removing dhcpcd from default services..."
       rc-service del dhcpcd default
   fi
   echo -e "\n"
fi

add_service "NetworkManager"

echo -e "${green}networkmanager successfully installed!${color_end}"
