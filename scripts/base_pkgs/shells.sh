#!/bin/bash

echo -e '
   _____ __         ____    
  / ___// /_  ___  / / /____
  \__ \/ __ \/ _ \/ / / ___/
 ___/ / / / /  __/ / (__  ) 
/____/_/ /_/\___/_/_/____/  

'
inform_msg "It is time to pick your shell!" "Currently only ZSH is supported for automated configuration"

# --------------- list of pkgs
shell_list=(
    "bash"
    "fish"
    "nushell"
    "zsh"
)

# --------------- map potential configuration paths to pkgs
declare -A conf_path_map
conf_path_map["bash"]="$HOME/.bashrc"
conf_path_map["fish"]="$CONFIG_DIR/fish/conf.fish"
conf_path_map["nushell"]="$CONFIG_DIR/nushell/conf.nu"
conf_path_map["zsh"]="$HOME/.zshrc"

# --------------- map dotfiles to pkg names
declare -A pkg_conf_map
pkg_conf_map["zsh"]="$HOME/.dotfiles/base_configs/shells/zsh/base.zsh"

# --------------- map packages to repo names
declare -A pkg_name_map
pkg_name_map["bash"]="app-shells/bash"
pkg_name_map["fish"]="app-shells/fish"
pkg_name_map["nushell"]="app-shells/nushell"
pkg_name_map["zsh"]="app-shells/zsh"


shells=()
select_shell() {
    cb() {
        echo -e "\n"

        local shell="$1"
        local repo_name="${pkg_name_map[$shell]}"
        local dot_file="${pkg_conf_map[$shell]}"
        local conf_path="${conf_path_map[$shell]}"

        # append loop iteration to global var
        shells+=("$shell")

        # conditional installation/backup of selections
        if pkg_exists "$shell"; then
            handle_backups "$shell" "$conf_path" "$dot_file"
        else
            echo -e "${cyan}Installing $shell...${color_end}"
            sudo emerge --ask "$repo_name"
            echo "Copying configuration for $shell into $conf_path"
            dynamic_copy "$dot_file" "$conf_path"
        fi
    }
    choose_multi "Select your shell(s)" cb "${shell_list[@]}"
    unset -f cb
}

#_____(MAIN SCRIPT)_____#

# TODO: Add prompt support (starship)

while true; do
    select_shell
    length="${#shells[@]}"

    if [ $length -gt 1 ]; then
        # handle multiple selections
        cb() {
            selection="$1"
            echo -e "${green}Marking $selection as the default shell"
            sudo chsh -s "/bin/$selection"
        }
        choose_one "Multiple shells selected. Choose one to be the default" "${shells[@]}"
        break
    elif [ $length -eq 0 ]; then
        # habndle no selections
        echo -e "${red}No selection was made. Please choose at least one.${color_end}"
    else
        # standard handling
        shell="${shells[@]}"
        echo -e "${green}Marking $shell as the default shell"    
        sudo chsh -s "/bin/$shell"
        break
    fi
done
