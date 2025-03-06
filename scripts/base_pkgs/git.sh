#!/bin/bash

git_config() {
    local user_name="$1"
    local user_email="$2"

    echo "Configuring Git for user: $user_name..."

    git config --global user.name "$user_name"
    git config --global user.email "$user_email"
    git config --global color.ui auto
}

if pkg_exists git; then
    gum_confirm "Git already installed. Proceed with configuration?"
    res=$?
    if [ $res -eq 1 ]; then
        exit 0
    fi
else
    echo -e "${cyan}Installing Git...${color_end}"
    sudo emerge --ask --noreplace dev-vcs/git
fi

SYSTEM_USER=$(whoami)

read -p "Enter your Git username for user '$SYSTEM_USER': " user_name
read -p "Enter your Git email for user '$SYSTEM_USER': " user_email

git_config "$user_name" "$user_email"

echo -e "${gren}Git configuration for user '$SYSTEM_USER' complete.${color_end}"
