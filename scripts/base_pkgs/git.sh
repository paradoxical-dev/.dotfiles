#!/bin/bash

echo '
   _______ __ 
  / ____(_) /_
 / / __/ / __/
/ /_/ / / /_  
\____/_/\__/  
              
'

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
    do_conf=$?
else
    do_conf=0
    echo -e "${cyan}Installing Git...${color_end}"
    sudo emerge --ask --noreplace dev-vcs/git
fi

SYSTEM_USER=$(whoami)

if [ $do_conf -eq 0 ]; then
    username=$(input "Enter your Git username for user '$SYSTEM_USER': " "user123")
    email=$(input "Enter your Git email for user '$SYSTEM_USER': " "example@email.com")

    git_config "$username" "$email"
    echo -e "${gren}Git configuration for user '$SYSTEM_USER' complete.${color_end}"
fi

echo -e "\n"

if ! pkg_exists "lazygit"; then
    echo -e "${cyan}Installing Lazygit...${color_end}"
    unmask_package "lazygit" "~amd64" "dev-vcs/lazygit"
else
    echo -e "${green}Lazygit already installed${color_end}"
fi

echo -e "\n"
