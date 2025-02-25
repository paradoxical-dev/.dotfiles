#!/bin/bash

PROFILE=""
PROFILE_DIR=""
THEME=""

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

if [[ -z "$PROFILE" ]]; then
    echo "Please provide a profile for installation using the --profile <profile> flag."
    echo "To view all available profiles use --list-profiles"
    exit 1
fi
PROFILE_DIR="$HOME/profiles/$PROFILE"

if [[ -z "$THEME" ]]; then
    echo "No theme set. Using default 'echelon' configurations..."
fi

export $PROFILE
export $PROFILE_DIR
export $THEME

echo "Wealcome to the install script."
echo "Preparing your system for the $PROFILE profile..."
echo " "

echo "Installing base system packages..."
$GOME/.dotfiles/scripts/base_pkgs/system_pkgs.sh

echo "Installing CLI tools..."
$HOME/.dotfiles/scripts/base_pkgs/cli.sh
