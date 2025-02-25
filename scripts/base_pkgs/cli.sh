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
    "fd"
    "figlet"
    "file"
    "fzf"
    "jq"
    "lesspipe"
    "lm_sensors"
    "lshw"
    "smartmontools"
    "tealdeer"
    "wikiman"
)

CONFIG_DIR=$(echo $XDG_CONFIG_HOME)
if [ -z "$CONFIG_DIR" ]; then
    CONFIG_DIR="$HOME/.config"
fi

# ------------- map packages to their config files
declare -A conf_path_map
conf_path_map["BOTtom"]="$CONFIG_DIR/bottom/bottom.toml"
conf_path_map["eza"]="$CONFIG_DIR/eza/theme.yml"
conf_path_map["fastfetch"]="$CONFIG_DIR/fastfetch/$THEME.conf"

# -------------- map packages to their repo names
declare -A pkg_name_map
pkg_name_map["bat"]="sys-apps/bat"
pkg_name_map["bc"]="sys-devel/bc"
pkg_name_map["bottom"]="sys-process/bottom"
pkg_name_map["chafa"]="media-gfx/chafa"
pkg_name_map["exiftool"]="media-libs/exiftool"
pkg_name_map["eza"]="sys-apps/eza"
pkg_name_map["fd"]="sys-apps/fd"
pkg_name_map["figlet"]="app-misc/figlet"
pkg_name_map["file"]="sys-apps/file"
pkg_name_map["fzf"]="app-shells/fzf"
pkg_name_map["jq"]="app-misc/jq"
pkg_name_map["lesspipe"]="app-text/lesspipe"
pkg_name_map["lm-sensors"]="sys-apps/lm-sensors"
pkg_name_map["lshw"]="sys-apps/lshw"
pkg_name_map["smartmontools"]="sys-apps/smartmontools"


# -------------- map dotfiles to package names
declare -A pkg_conf_map
pkg_conf_map["bottom"]="$HOME/.dotfiles/base_configs/cli/bottom/$THEME.toml"
pkg_conf_map["eza"]="$HOME/.dotfiles/base_configs/cli/eza/$THEME.yml"
pkg_conf_map["fastfetch"]="$HOME/.dotfiles/base_configs/cli/fastfetch/$THEME.conf"


#===================================#
#       FUNCTION DECLARATION        #
#====================================

command_exists() {
    command -v "$1" &> /dev/null
}

# -------------- what to do if a package is already installed
handle_backups(){
    local conf_path="${conf_path_map["$1"]}"
    local dot_file="${pkg_conf_map["$pkg"]}"

    if [[ ! -z "$conf_path" ]]; then
        if [[ -e "$conf_path" ]]; then
	    while true; do
	        read -p "Config file found for $1, move to .bak? [y/n]: " backup_config
		case "$backup_config" in
		    [Yy]) 
		        mv "$conf_path" "$conf_path.bak"; 
	                echo "Copying config file $dot_file to $conf_path"
	                cp "$dot_file" "$conf_path"
			break 
		    ;;
		    [Nn]) 
		        echo "Overwriting config file at $conf_path with $dot_file..."
	    		cp "$dot_file" "$conf_path"
	    		if [ $? -eq 1 ]; then
	        	    mkdir -p $conf_path
			    cp "$dot_file" "$conf_path"
	    		fi
			break 
		    ;;
		    *) 
		        echo "Invalud input. Please enter 'y' or 'n'" 
		    ;;
		esac
	    done
	elif [[ ! -z "$dot_file" && -e $dot_file ]]; then
	    echo "Copying config file $dot_file to $conf_path"
	    cp "$dot_file" "$conf_path"
	    if [ $? -eq 1 ]; then
	        mkdir -p "$conf_path"
		cp "$dot_file" "$conf_path"
	    fi
	fi
    else
        echo "No config file required for $1"
    fi
}

# ------------- build ddgr from source
ddgr_build() {
    local repo_url="https://github.com/jarun/ddgr"
    local python_exists=command_exists "python"

    if [[ ! $python_exists ]]; then
        echo "No python version detected. Emerging python..."
	sudo emerge --ask --noreplace "dev/lang-python"
    fi

    while true; do
        read -p "Where to clone ddgr? Exclude repo name (default $HOME/src): " clone_location
	case $clone_location in
	    *)
	        if [[ -z "$clone_location" ]]; then
		    $clone_location="$HOME/src"
		    break
		elif [[ -e "$clone_location" ]]; then
		    break
                else
		    echo "$clone_location is not a valid path. Please enter a valid path to clone the repo."
		fi
	    ;;
	esac
    done

    echo "Cloning latest repo into $clone_location..."
    git clone "$repo_url" "$clone_location"
    cd "$clone_location/ddgr"
    echo "Installing ddgr..."
    sudo make install
}

# -------------- build wikiman from source
wikiman_build() {
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

    declare -A dep_name_map
    dep_name_map["man"]="sys-apps/man-db"
    dep_name_map["fzf"]="app-shells/fzf"
    dep_name_map["ripgrep"]="sys-apps/ripgrep"
    dep_name_map["awk"]="app-alternatives/awk"
    dep_name_map["w3m"]="www-client/w3m"
    dep_name_map["coreutils"]="sys-apps/coreutils"
    dep_name_map["parallel"]="sys-process/parallel"

    echo "Checking dependencies..."
    for pkg in $deps; do
        if ! ls /var/db/pkg/*/"$pkg"-* &>/dev/null; then
	   echo "Dependency $pkg not installed. Installing now..."
	   sudo emerge --ask --noreplace $pkg_name
	fi
    done

    echo "Cloning wikiman repo..."
    while true; do
        read -p "Where to clone wikiman? Exclude repo name (default $HOME/src): " clone_location
	case $clone_location in
	    *)
	        if [[ -z "$clone_location" ]]; then
		    $clone_location="$HOME/src"
		    break
		elif [[ -e "$clone_location" ]]; then
		    break
                else
		    echo "$clone_location is not a valid path. Please enter a valid path to clone the repo."
		fi
	    ;;
	esac
    done

    git clone "$repo_url" "$clone_location"
    cd "$clone_location/wikiman"
    echo "Installing wikiman..."
    sudo make all
    sudo make install
}



#==========================#
#       MAIN SCRIPT        #
#==========================#

main() {
    for pkg in pkg_list; do
        local pkg_name="${pkg_name_map["$pkg"]}"
	local dot_file="${pkg_conf_map["$pkg"]}"
	local conf_path="${conf_path_map["$pkg"]}"

        if [[ "$pkg" -eq "bottom" ]]; then
	    local valid_command=command_exists "btm" 
        else
	    local valid_command=command_exists "$pkg"
	fi

	if [[ $valid_command ]]; then
	    echo "$pkg already installed. Checking for config files"
	    handle_backups "$pkg"
	else
	    echo "Installing $pkg..."
	    if [[ "$pkg" -eq "ddgr" ]]; then
	        echo "No emerge package found for ddgr. Building from source..."
		ddgr_build
	    elif [[ "$pkg" -eq "tealdeer" ]]; then
	        echo "No emerge package found for tealdeer. Building using cargo..."
		local cargo_exists=command_exists "cargo"
		if [[ $cargo_exists ]]; then
		    cargo install tealdeer
		else
		    echo "Cargo not available. Emerging latest rust version..."
		    sudo emerge --ask --noreplace "dev-lang/rust"
		    cargo install tealdeer
		fi
	    elif [[ "$pkg" -eq "wikiman" ]]; then
	        echo "No emerge package found for wikiman. Building from source..."
		wikiman_build
	    else
	        sudo emerge --ask --noreplace "$pkg_name"
	        if [[ ! -z "$dot_file" && -e $dot_file ]]; then
	            echo "Copying config file $dot_file to $conf_path"
	            cp $dot_file $conf_path
	            if [ $? -eq 1 ]; then
	                mkdir -p $conf_path
	                cp $dot_file $conf_path
	            fi
	        fi
	    fi
	fi
    done
}

main
