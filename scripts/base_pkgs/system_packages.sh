#!/bin/bash

pkg_list=(
    "neovim" 
    "parallel" 
    "ripgrep" 
    "tmux" 
    "unzip" 
    "upower"
)

declare -A pkg_name_map
pkg_name_map["parallel"]="sys-process/parallel"
pkg_name_map["ripgrep"]="sys-apps/ripgrep"
pkg_name_map["unzip"]="app-arch/unzip"
pkg_name_map["upower"]="sys-power/upower"


neovim_install() {
    local nvim_conf_path="$HOME/.dotfiles/base_configs/nvim"
    local valid_command
    command_exists "nvim"
    valid_command=$?

    if [ $valid_command -eq 0 ]; then
        cb() {
            local selection="$1"
            case "$selection" in
                "Move config to .bak")
                    mv "$CONFIG_DIR/nvim" "$CONFIG_DIR/nvim.bak"; 
                    echo -e "${green}Backup cpmplete${color_end}"
                    echo "Copying configuration into $CONFIG_DIR/nvim"
                    cp -r "$nvim_conf_path" "$CONFIG_DIR/nvim"
                    ;;
                "Overwrite config")
                    echo -e "${orange}Overwriting config file at $conf_path with $dot_file...${color_end}"
                    rm -r "$CONFIG_DIR/nvim"
                    cp -r "$nvim_conf_path" "$CONFIG_DIR/nvim"
                    ;;
                "Skip")
                    echo "Skipping configuration of neovim"
                    ;;
            esac
        }
        local choices=("Move config to .bak" "Overwrite config" "Skip")
        local prompt="Configuration found for neovim. Next steps?"
        choose_one "$prompt" cb "${choices[@]}"

        unset -f cb
    else
        echo -e "${cyan}Installing Neovim...${color_end}"
        sudo emerge --ask --noreplace "app-editors/neovim"
        echo "Copying configuration to $CONFIG_DIR/nvim"
        cp -r "$nvim_conf_path" "$COFNIG_DIR/nvim"
    fi
}

tmux_install() {
    local tmux_conf_path="$HOME/.dotfiles/base_configs/tmux/$THEME.conf"
    local valid_command
    command_exists "tmux"
    valid_command=$?

    if [[ $valid_command -eq 0 ]]; then
        cb() {
            local selection="$1"
            case "$selection" in
                "Move config to .bak")
                    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
                    echo -e "${green}Backup cpmplete${color_end}"
                    echo "Copying configuration into $HOME/.tmux.conf..."
                    cp "$tmux_conf_path" "$HOME/.tmux.conf"
                    ;;
                "Overwrite config")
                    echo -e "${orange}Overwriting $HOME/.tmux.conf...${color_end}" 
                    cp "$tmux_conf_path" "$HOME/.tmux.conf"
                    ;;
                "Skip")
                    echo "Skipping configuration of tmux"
                    ;;
            esac
        }
        local choices=("Move config to .bak" "Overwrite config" "Skip")
        local prompt="Configuration found for tmux. Next steps?"
        choose_one "$prompt" cb "${choices[@]}"

        unset -f cb
    else
        echo "${cyan}Installing tmux...${color_end}"
        sudo emerge --ask --noreplace "app-misc/tmux"
        echo "Copying configuration to $HOME/.tmux.conf"
        cp "$tmux_conf_path" "$HOME/.tmux.conf"

        echo "Cloning tpm repo..."
        git clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
    fi
}

for pkg in "${pkg_list[@]}"; do
    echo -e "\n"
    if [[ "$pkg" == "neovim" ]]; then
        neovim_install
    elif [[ "$pkg" == "tmux" ]]; then
        tmux_install
    else
        pkg_name="${pkg_name_map[$pkg]}"
        if command_exists "$pkg" || ls /var/db/pkg/*/"$pkg"-* &> /dev/null; then
            echo -e "${green}$pkg already installed"
        else
            echo -e "${cyan}Installing $pkg...${color_end}"
            sudo emerge --ask --noreplace "$pkg_name"
        fi
    fi
done
