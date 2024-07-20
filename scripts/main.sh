#!/bin/bash

#==============================#
#            SETUP             #
#==============================#

PROFILE=""
PROFILE_DIR=""
THEME=""
LAPTOP=1

# --------------- grab the passed options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --profile)
	    PROFILE="$2"    
	    shift 2
	;;
	--theme)
	    THEME="$2"
	    shift 2
	;;
	--list-profiles)
	    echo "Desktop:"
	    echo "  Hyprland (desktop/hypr)"
	    echo "Server:"
	    echo "  Minimal (server/minimal)"
	    echo "  Hardened (server/hardened)"
	    echo "Raspberry Pi:"
	    echo "  "
	    exit 0
	;;
    --laptop)
        LAPTOP=0
        shift
    ;;
	*)
	    echo "Unknown option: $1"
	    exit 1
	;;
    esac
done

# --------------- handle opts accordingly
if [[ -z "$PROFILE" ]]; then
    echo "Please provide a profile for installation using the --profile <profile> flag."
    echo "To view all available profiles use --list-profiles"
    exit 1
fi
PROFILE_DIR="$HOME/profiles/$PROFILE"

if [[ -z "$THEME" ]]; then
    echo "No theme set. Using default 'echelon' configurations..."
fi

CONFIG_DIR=$(echo $XDG_CONFIG_HOME)
if [ -z "$CONFIG_DIR" ]; then
    CONFIG_DIR="$HOME/.config"
fi

# ------------ color definitions
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

# ------------ export script-wide vars
# ------ opts
export PROFILE=$PROFILE
export PROFILE_DIR=$PROFILE_DIR
export THEME=$THEME
export LAPTOP=$LAPTOP
export CONFIG_DIR=$CONFIG_DIR

# ------ colors
export red=$red
export green=$green
export yellow=$yellow
export blue=$blue
export magenta=$magenta
export cyan=$cyan
export orange=$orange
export color_end=$end

# ------ common commands
export gum="$HOME/go/bin/gum"

# --------------- common functions
for script in "$HOME/.dotfiles/scripts/functions/"*; do
    source "$script"
done

#===============================#
#          MAIN SCRIPT          #
#===============================#

# --------------- handle gum dependency
if [[ ! -e $HOME/go/bin/gum ]]; then
    echo -e "${yellow}gum is required to run this script${color_end}"
    echo "Installing now..."
    echo -e "\n"
    if ! pkg_exists "go"; then
        echo "${teal}No go version found. Emerging latest version...${color_end}"
        sudo emerge --ask --noreplace "dev-lang/go"
    fi
    go install "github.com/charmbracelet/gum@latest"
    echo -e "\n"
fi

echo -e "\n"
greet
inform_msg "Before installation, the GURU repository will need to be added..."
echo -e "\n"

# --------------- install/update GURU repo
if [[ -e "/var/db/repos/guru/" ]]; then
    echo "GURU repository alredy exists"    
else
    if ! ls "/var/db/pkg/*/eselect-repository-*" &> /dev/null; then
        echo "eselect-repository not installed..."
        sudo emerge --ask --verbose "app-eselect/eselect-repository"
    fi
    sudo eselect repository enable guru
fi
gum_confirm "Would you like to sync the database? [recommended]"
sync_db=$?
if [ $sync_db -eq 0 ]; then
    sudo emerge --sync
fi
echo -e "\n"

# --------------- git config
echo "First things first, lets make sure Git is configured"
$HOME/.dotfiles/scripts/base_pkgs/git.sh

# --------------- Base system packages before moving to profile specific
echo "Installing base system packages..."
$HOME/.dotfiles/scripts/base_pkgs/system_packages.sh

echo "Installing CLI tools..."
$HOME/.dotfiles/scripts/base_pkgs/cli.sh

echo "Adding services..."
$HOME/.dotfiles/scripts/base_pkgs/services.sh

# --------------- theme file creation 
echo "Creating file to store theme value."
while true; do
    theme_file=$(input "Where to store file? (default $HOME/.system-theme) INCLUDING FILE NAME" "path/to/system-theme")
    case "$theme_file" in
        *) 
            if [[ -z "$theme_file" ]]; then
                theme_file="$HOME/.system-theme"
                break
            elif [[ -e "$clone_location" ]]; then
                break
            else
                echo -e "${red}$clone_location is not a valid path. Please enter a valid path to clone the repo.${color_end}"
            fi
            ;;
    esac
done
echo "$THEME" > "$theme_file"

# --------------- shell select
$HOME/.dotfiles/scripts/base_pkgs/shells.sh

# --------------- Profile specific
# TODO: start porting over hypr conf, wayland support, etc.
