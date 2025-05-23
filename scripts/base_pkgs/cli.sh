#!/bin/bash

#===================================#
#       VARIABLE DECLARATION        #
#====================================

pkg_list=(
    "bat"
    "bc"
    "bottom"
    "chafa"
    "ddgr"
    "exiftool"
    "eza"
    "fastfetch"
    "fd"
    "figlet"
    "file"
    "fzf"
    "jq"
    "lesspipe"
    "lm-sensors"
    "lshw"
    "smartmontools"
    "tealdeer"
    "wikiman"
)

# ------------- map packages to their config files
declare -A conf_path_map
conf_path_map["bottom"]="$CONFIG_DIR/bottom/bottom.toml"
conf_path_map["eza"]="$CONFIG_DIR/eza/theme.yml"
conf_path_map["fastfetch"]="$CONFIG_DIR/fastfetch/$THEME.jsonc"

# -------------- map packages to their repo names
declare -A pkg_name_map
pkg_name_map["bat"]="sys-apps/bat"
pkg_name_map["bc"]="sys-devel/bc"
pkg_name_map["bottom"]="sys-process/bottom"
pkg_name_map["chafa"]="media-gfx/chafa"
pkg_name_map["exiftool"]="media-libs/exiftool"
pkg_name_map["eza"]="sys-apps/eza"
pkg_name_map["fastfetch"]="app-misc/fastfetch"
pkg_name_map["fd"]="sys-apps/fd"
pkg_name_map["figlet"]="app-misc/figlet"
pkg_name_map["file"]="sys-apps/file"
pkg_name_map["fzf"]="app-shells/fzf"
pkg_name_map["jq"]="app-misc/jq"
pkg_name_map["lesspipe"]="app-text/lesspipe"
pkg_name_map["lm_sensors"]="sys-apps/lm-sensors"
pkg_name_map["lshw"]="sys-apps/lshw"
pkg_name_map["smartmontools"]="sys-apps/smartmontools"
pkg_name_map["tealdeer"]="app-misc/tealdeer"


# -------------- map dotfiles to package names
declare -A pkg_conf_map
pkg_conf_map["bottom"]="$REPO_DIR/base_configs/cli/bottom/$THEME.toml"
pkg_conf_map["eza"]="$REPO_DIR/base_configs/cli/eza/$THEME.yml"
pkg_conf_map["fastfetch"]="$REPO_DIR/base_configs/cli/fastfetch/$THEME.jsonc"


#===================================#
#       FUNCTION DECLARATION        #
#====================================

# -------------- build ddgr from source
ddgr_build() {
    gum_confirm "No ebuild found for ddgr. Build from source?"
    local res=$?
    if [ $res -eq 1 ]; then
        echo "Skipping installation..."
        return 0
    fi

    local repo_url="https://github.com/jarun/ddgr"
    local python_exists=pkg_exists "python"

    if [[ ! $python_exists ]]; then
        echo "No python version detected. Emerging python..."
        sudo emerge --ask --noreplace "dev/lang-python"
    fi

    while true; do
        local clone_location=$(input "Where to clone ddgr? (default $HOME/src/ddgr)" "path/to/repo")
        case $clone_location in
            *)
                if [[ -z "$clone_location" ]]; then
                    if [[ ! -e "$HOME/src" ]]; then
                        echo -e "Creating directory $HOME/src"
                        mkdir $HOME/src
                    fi
                    clone_location="$HOME/src/ddgr"
                    break
                elif [[ -e "$clone_location" ]]; then
                    break
                else
                    echo -e "${red}$clone_location is not a valid path. Please enter a valid path to clone the repo.${color_end}"
                fi
                ;;
        esac
    done

    echo -e "${teal}Cloning ddgr repo into $clone_location...${color_end}"
    git clone "$repo_url" "$clone_location"
    cd "$clone_location"
    echo -e "${teal}Installing ddgr...${color_end}"
    spinner "Installing ddgr..." sudo make install
}

# -------------- build wikiman from source or skip
wikiman_build() {
    gum_confirm "No ebuild present for wikiman. Build from source?"
    local res=$?
    if [ $res -eq 1 ]; then
        echo "Skipping installation..."
        return 0
    fi

    local repo_url="https://github.com/filiparag/wikiman"
    local deps=(
        "man"
        "fzf"
        "ripgrep"
        "awk"
        "w3m"
        "coreutils"
        "parallel"
    )

    # ------------- dependency management
    declare -A dep_name_map
    dep_name_map["man"]="sys-apps/man-db"
    dep_name_map["fzf"]="app-shells/fzf"
    dep_name_map["ripgrep"]="sys-apps/ripgrep"
    dep_name_map["awk"]="app-alternatives/awk"
    dep_name_map["w3m"]="www-client/w3m"
    dep_name_map["coreutils"]="sys-apps/coreutils"
    dep_name_map["parallel"]="sys-process/parallel"

    echo "Checking dependencies..."
    for pkg in "${deps[@]}"; do
        local pkg_name="${dep_name_map[$pkg]}"
        if ! ls /var/db/pkg/*/"$pkg"-* &> /dev/null; then
            echo -e "${orange}Dependency $pkg not installed. Installing now...${color_end}"
            sudo emerge --ask --noreplace "$pkg_name"
        fi
    done


    # ------------- clone repo
    echo -e "${cyan}Cloning wikiman repo...${color_end}"
    while true; do
        local clone_location=$(input "Where to clone wikiman? (default $HOME/src/wikiman)" "path/to/repo")
        case $clone_location in
            *)
                if [[ -z "$clone_location" ]]; then
                    if [[ ! -e "$HOME/src" ]]; then
                        echo "Creating directory $HOME/src"
                        mkdir $HOME/src
                    fi
                    clone_location="$HOME/src/wikiman"
                    break
                elif [[ -e "$clone_location" ]]; then
                    break
                else
                    echo "${red}$clone_location is not a valid path. Please enter a valid path to clone the repo.$color_end"
                fi
                ;;
        esac
    done

    git clone "$repo_url" "$clone_location"
    cd "$clone_location"
    spinner "Installing wikiman" sudo make all && sudo make install

    # -------------- install additional sources
    sources_cb() {
        local source="$1"
        spinner "Installing $source source..." make "source-${source}"
    }

    cd "$clone_location"
    local sources=("gentoo" "arch" "fbsd" "tldr")
    local prompt="Select which sources to install for wikiman"
    choose_multi "$prompt" sources_cb "${sources[@]}"
    spinner "Finalizing sources..." sudo make source-install

    unset -f sources_cb
}

# -------------- handle how to install tealdeer
handle_tealdeer() {
    cb() {
        local selection=$1
        case "$selection" in
            "Skip install")
                echo -e "${orange}Skipping tealdeer installation${color_end}"
                ;;
            "Unmask package")
                local tealdeer_pkg="${pkg_name_map[tealdeer]}"
                sudo echo "$tealdeer_pkg ~amd64" >> /etc/portage/package.accept_keywords/tealdeer
                echo -e "${green}Package unmasked with /etc/portage/package.accept_keywords/tealdeer${color_end}"
                echo -e "${cyan}Installing tealdeer...${color_end}"
                sudo emerge --ask --noreplace "$tealdeer_pkg"
                ;;
            "Build with cargo")
                if pkg_exists "cargo"; then
                    echo -e "${cyan}Installing tealdeer..."
                    cargo install tealdeer
                else
                    echo -e "${orange}Cargo not available. Emerging latest rust version..."
                    sudo emerge --ask --noreplace "dev-lang/rust"
                    echo -e "${cyan}Installing tealdeer...${color_end}"
                    cargo install tealdeer
                fi
        esac
    }

    local methods=("$@")
    local prompt="Package tealdeer is masked by keyword ~amd64. How to proceed?"
    choose_one "$prompt" cb "${methods[@]}"

    unset -f cb
}

# -------------- handle edge case faciliation
handle_edge() {
    local case="$1"
    if [[ "$case" == "ddgr" ]]; then
        if pkg_exists "ddgr"; then
            echp -e "${green}ddgr already installed${color_end}"
        else
            ddgr_build
        fi
    elif [[ "$case" == "tealdeer" ]]; then
        if [[ -e "$HOME/.cargo/bin/tldr" || $(pkg_exists "tealdeer") ]]; then
            echo -e "${green}tealdeer already installed${color_end}"
        else
            echo -e "${cyan}Installing tealdeer${color_end}"
            local methods=("Skip install" "Unmask package" "Build with Cargo")
            handle_tealdeer "${methods[@]}"
        fi
    elif [[ "$case" == "wikiman" ]]; then
        if  pkg_exists "wikiman"; then
            echo -e "${green}wikiman already installed${color_end}"
        else
            wikiman_build
        fi
    fi
}

#==========================#
#       MAIN SCRIPT        #
#==========================#

main() {
    for pkg in "${pkg_list[@]}"; do
        echo -e "\n"

        # define the packages mapped values
        local pkg_name="${pkg_name_map[$pkg]}"
        local dot_file="${pkg_conf_map[$pkg]}"
        local conf_path="${conf_path_map[$pkg]}"

        # define whether the package exists
        local exists
        pkg_exists "$pkg"
        exists=$?

        if [ $exists -eq 0 ]; then
            # handle potential backups
            echo -e "${green}$pkg already installed. Checking for config files...${color_end}"
            handle_backups "$pkg" "$conf_path" "$dot_file"
        else
            # handle edge cases
            if [[ "$pkg" == "ddgr" || "$pkg" == "wikiman" || "$pkg" || "tealdeer" ]]; then
                handle_edge "$pkg"
            else
                # install otherwise
                echo -e "${cyan}Installing $pkg...$color_end"
                sudo emerge --ask --noreplace "$pkg_name"
                # copy config if available
                if [[ ! -z "$dot_file" && -e "$dot_file" ]]; then
                    echo -e "\n"
                    echo "Copying config file $dot_file to $conf_path"
                    dynamic_copy "$dot_file" "$conf_path"
                fi
            fi
        fi
    done
}

main
