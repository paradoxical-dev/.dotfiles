#!/bin/bash

git_config() {
    local user_name="$1"
    local user_email="$2"

    echo "Configuring Git for user: $user_name..."

    git config --global user.name "$user_name"
    git config --global user.email "$user_email"
    git config --global color.ui auto
}

if command_exists git; then
    echo "Git already installed; skipping setup"
    exit 1
else
    echo "Installing Git..."
    sudo emerge --ask --noreplace dev-vcs/git
fi

SYSTEM_USER=$(whoami)

read -p "Enter your Git username for user '$SYSTEM_USER': " user_name
read -p "Enter your Git email for user '$SYSTEM_USER': " user_email

git_config "$user_name" "$user_email"

echo "Git configuration for user '$SYSTEM_USER' complete."
