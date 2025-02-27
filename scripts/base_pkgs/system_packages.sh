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

    if [[ $valid_command -eq 0 ]]; then
        while true; do
            echo "!!! ENTERING N WILL OVERWRITE CURRENT CONFIG"
            read -p "Neovim already isntalled. Backup config directory? [y/n]: " backup_neovim
            case "$backup_neovim" in
                [Yy])
                    echo "Moving $CONFIG_DIR/nvim to $CONFIG_DIR/nvim.bak..."
                    mv "$CONFIG_DIR/nvim" "$CONFIG_DIR/nvim.bak"
                    echo "Copying configuration into $CONFIG_DIR/nvim..."
                    cp -r "$nvim_conf_path" "$CONFIG_DIR/nivm"
                    break
                    ;;
                [Nn])
                    echo "Overwriting $CONFIG_DIR/nvim..." 
                    rm -r "$CONFIG_DIR/nvim"
                    cp -r "$nvim_conf_path" "$CONFIG_DIR/nvim"
                    break
                    ;;
                *)
                    echo "Invalud input. Please enter 'y' or 'n'" 
                    ;;
            esac
        done
    else
        echo "Installing Neovim..."
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
        while true; do
            echo "!!! ENTERING N WILL OVERWRITE CURRENT CONFIG"
            read -p "tmux already isntalled. Backup config? [y/n]: " backup_tmux
            case "$backup_tmux" in
                [Yy])
                    echo "Moving $HOME/.tmux.conf to $HOME/.tmux.conf.bak..."
                    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
                    echo "Copying configuration into $HOME/.tmux.conf..."
                    cp "$tmux_conf_path" "$HOME/.tmux.conf"
                    break
                    ;;
                [Nn])
                    echo "Overwriting $HOME/.tmux.conf..." 
                    cp "$tmux_conf_path" "$HOME/.tmux.conf"
                    break
                    ;;
                *)
                    echo "Invalud input. Please enter 'y' or 'n'" 
                    ;;
            esac
        done
    else
        echo "Installing tmux..."
        sudo emerge --ask --noreplace "app-misc/tmux"
        echo "Copying configuration to $HOME/.tmux.conf"
        cp "$tmux_conf_path" "$HOME/.tmux.conf"

        echo "Cloning tpm repo..."
        git clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
    fi
}

for pkg in "${pkg_list[@]}"; do
    if [[ "$pkg" == "neovim" ]]; then
        echo "calling neovim install"
        neovim_install
    elif [[ "$pkg" == "tmux" ]]; then
        tmux_install
    else
        pkg_name="${pkg_name_map[$pkg]}"
        echo "Installing $pkg..."
        sudo emerge --ask --noreplace "$pkg_name"
    fi
done
