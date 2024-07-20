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
    add_service "$service"
done

if [ $LAPTOP -eq 0 ]; then
    echo "Lapttop installation detected"
    echo -e "${cyan}Installing TLP for power optimizations...${color_end}"
    sudo emerge --ask --noreplace "sys-power/tlp"
    add_service "tlp"
    sudo tlp start
fi
