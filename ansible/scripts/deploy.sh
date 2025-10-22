#!/bin/bash

#==================================================================#
#  Script will kick off the ansible post installation autmoation.  #
#  Checks for the base packages (ansible, gum) and proompts user   #
#     for device/profile type before starting installation.        #
#==================================================================#

set -e

yellow="\e[1;33m"
color_end="\e[1;0m"

pkg_exists() {
    qlist -I "$1" &> /dev/null || command -v "$1" &> /dev/null
}

if ! pkg_exists "ansible"; then
    echo -e "${yellow}ansible not yet installed.\n${color_end}"
    echo -e "${yellow}Installing ansible now...${color_end}"
    sudo emerge --oneshot --verbose "app-admin/ansible"
fi

# TODO:  will need to be changed once scripts dir is mergerd to main repo
ANSIBLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ANSIBLE_DIR"

ansible-playbook --ask-become-pass test.yml

