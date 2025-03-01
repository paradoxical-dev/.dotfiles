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

# --------------- color definitions
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

# --------------- export script-wide vars
# ------ opts
export PROFILE=$PROFILE
export PROFILE_DIR=$PROFILE_DIR
export THEME=$THEME
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

#================================#
#        COMMON FUNCTIONS        #
#================================#

# TODO: Move function declaration to external script
# This will be called by the main script to export them

# @param {string} command
command_exists() {
    command -v "$1" &> /dev/null
}

# @param {string} package name
# @param {list | string} keywords
# @param {string} emerge package name 
# Prompt the user on whether or not to mask the current package
unmask_package() {
    local pkg=$1
    local keywords=$2
    local pkg_repo=$3

    echo -e "$orangeThe package $pkg is currently masked by keyword(s) $keywords $color_end"
    local unmask=$($gum confirm "Unmask package $1?" --prompt.foreground "#0fe" \
    selected.background "#0fe")

    # if [ $unmask -eq 0 ]; then
    #     sudo echo "$pkg_repo $keywords" >> "/etc/portage/package.accept_keywords/$pkg"
    # else
    #     echo "Skipping installtion of $pkg"
    # fi
}

# @param {string} header prompt
# @param {function | command} callback for selection
# @param {list} list of choices
choose_one() {
    local header="$1"
    local cb="$2"
    shift 2
    local choices=("$@")

    local selection=$($gum choose --cursor.foreground "#0fe" \
    --selected.foreground "#0fe" --header.foreground "#f0e" \
    --header="$header" "${choices[@]}")

    "$cb"  "$selection"
}

# @param {string} header prompt
gum_confirm() {
    local header="$1"
    
    $gum confirm "$header" \
    --selected.background "#0fe" \
    --prompt.foreground "#0fe"
}

# @param {string} spinner prompt
# @param {command} command to wait on
spinner() {
    local title="$1"
    shift

    $gum spin --title "$title" \
    --spinner "points" \
    --spinner.foreground "#0fe" \
    -- "$@"
}

inform_msg() {
    $gum format --border-foregound "#0fe" --border "rounded" \
    --align "center" --width 50 --margin "1 2" --padding "2 4" \
    "$@"
}

input() {
    local header="$1"
    local placeholder="$2"

    $gum input --header "$header" --placeholder "$placeholder" \
    --header.foreground "#0fe" --prompt.foreground "#0fe" \
    --cursor.foreground "#fff"
}

export -f command_exists
export -f unmask_package
export -f choose_one
export -f gum_confirm
export -f spinner
export -f input

#===============================#
#          MAIN SCRIPT          #
#===============================#

echo -e "${cyan}Wealcome to the install script!${color_end}"
echo -e "\n"
echo "Before installation, the GURU repository will need to be added..."
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

echo "git and gum packages are required for the remainder of this script"
echo -e "${cyan}Installing now...${color_end}"
echo -e "\n"
$HOME/.dotfiles/scripts/base_pkgs/git.sh
$HOME/.dotfiles/scripts/base_pkgs/gum.sh

# --------------- Base system packages before moving to profile specific
echo "Installing base system packages..."
$HOME/.dotfiles/scripts/base_pkgs/system_packages.sh

echo "Installing CLI tools..."
$HOME/.dotfiles/scripts/base_pkgs/cli.sh


