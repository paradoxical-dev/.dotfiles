#!/bin/bash

# INFO: This holds the required serviees provided by
# the base packages. It will activate each only after
# the packages have been installed

# TODO: Review services
services=(
    "dbus"
    "acpid"
)

for service in "${services[@]}"; do
    echo -e "\n"
    add_service "$service" "default"
    echo -e "\n"
done

if [ $LAPTOP -eq 0 ]; then
    echo "Laptop installation detected"
    if ! pkg_exists "tlp"; then
        echo -e "${cyan}Installing TLP for power optimizations...${color_end}"
        sudo emerge --ask --noreplace "sys-power/tlp"
        add_service "tlp" "default"
        sudo tlp start
    else
        echo -e "${green}TLP already installed...${color_end}"
    fi
fi

if ! pkg_exists "elogind"; then
    gum_confirm "Would you like to install and add elogind? (ONLY FOR OPEN-RC BUILDS)"
    install=$?
    if [ $install -eq 0 ]; then
        sudo emerge --ask "sys-auth/elogind"
        add_service "elogind" "boot"
    fi
fi
