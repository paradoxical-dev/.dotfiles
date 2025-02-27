#!/bin/bash

#===============================#
#      OPTS INITIALIZATION      #
#===============================#

PROFILE=""
PROFILE_DIR=""
THEME=""

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

# --------------- export script-wide vars
export PROFILE=$PROFILE
export PROFILE_DIR=$PROFILE_DIR
export THEME=$THEME
export CONFIG_DIR=$CONFIG_DIR

#================================#
#        COMMON FUNCTIONS        #
#================================#

command_exists() {
    command -v "$1" &> /dev/null
}



export -f command_exists


#===============================#
#          MAIN SCRIPT          #
#===============================#

echo "Wealcome to the install script."
echo "Preparing your system for the $PROFILE profile..."
echo " "

# --------------- Base system packages before moving to profile specific
echo "Installing base system packages..."
$HOME/.dotfiles/scripts/base_pkgs/system_packages.sh

echo "Installing CLI tools..."
$HOME/.dotfiles/scripts/base_pkgs/cli.sh


