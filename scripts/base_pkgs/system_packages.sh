#!/bin/bash

pkg_list=(
    "acpi"
    "acpid"
    "neovim" 
    "parallel" 
    "ripgrep" 
    "tmux" 
    "unzip" 
)

# --------------- map packages to repo names
declare -A pkg_name_map
pkg_name_map["acpi"]="sys-power/acpi"
pkg_name_map["acpid"]="sys-power/acpid"
pkg_name_map["parallel"]="sys-process/parallel"
pkg_name_map["ripgrep"]="sys-apps/ripgrep"
pkg_name_map["unzip"]="app-arch/unzip"

# --------------- map packages to potential user configs
declare -A conf_path_map
conf_path_map["neovim"]="$CONFIG_DIR/nvim"
conf_path_map["tmux"]="$HOME/.tmux.conf $CONFIG_DIR/tmux/tmux.conf"

# --------------- map packages to stored configs
declare -A pkg_conf_map
pkg_conf_map["neovim"]="$REPO_DIR/base_configs/nvim"
pkg_conf_map["tmux"]="$REPO_DIR/base_configs/tmux/$THEME.conf"

main() {
    for pkg in "${pkg_list[@]}"; do
        echo -e "\n"

        local conf_path="${conf_path_map[$pkg]}"
        local dot_file="${pkg_conf_map[$pkg]}"
        local pkg_name="${pkg_name_map[$pkg]}"

        if pkg_exists "$pkg"; then
            echo -e "${green}$pkg already installed. Checking for config files..."
            handle_backups "$pkg" "$conf_path" "$dot_file"
        else
            echo -e "${cyan}Installing $pkg...${color_end}"
            sudo emerge --ask --noreplace "$pkg_name"
            if [[ ! -z "$dot_file" && -e "$dot_file" ]]; then
                echo "Copying config file $dot_file to $conf_path"
                dynamic_copy "$dot_file" "$conf_path"
            fi
        fi
    done
}

main
