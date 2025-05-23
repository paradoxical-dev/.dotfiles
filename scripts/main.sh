#!/bin/bash

# TODO: Move neovim config to its own repo

#==============================#
#            SETUP             #
#==============================#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

#======(OPTS)======#

PROFILE=""
PROFILE_DIR=""
THEME=""
EDIT_USE=0
LAPTOP=1
SKIP_BACKUPS=1

# --------------- grab the passed options
while [[ $# -gt 0 ]]; do
    case "$1" in
    --help)
        echo "Usage: <repo name>/scripts/main.sh [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --profile <name>        Specify the profile to use (e.g., desktop/hypr, server/minimal)."
        echo "  --theme <name>          Specify the theme to apply (default: echelon)"
        echo "  --laptop                Apply laptop-specific configuration tweaks."
        echo "  --no-edit-use           Skip prompting to edit USE flags for certain packages."
        echo "  --skip-backups          Skip prompt for backups. Using this flag will not copy over any configuratio files if ones already exist."
        echo "  --list-profiles         List available profiles by category and exit."
        echo "  --help                  Show this help message and exit."
        echo ""
        echo "Examples:"
        echo "  .dotfiles/scripts/main.sh --profile desktop/hypr --theme echelon --laptop"
        echo "  ./main.sh --list-profiles"
        exit 0
    ;;
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
    --no-edit-use)
        EDIT_USE=1
        shift
    ;;
    --skip-backups)
        SKIP_BACKUPS=0
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
PROFILE_DIR="$REPO_DIR/profiles/$PROFILE"
if [[ ! -d "$PROFILE_DIR" ]]; then
    echo "$PROFILE_DIR"
    echo "Profile $PROFILE does not exist. Please select an available profile."
    echo "To view all available profiles use --list-profiles"
    exit 1
fi

themes=(
    "echelon"
)
if [[ -z "$THEME" ]]; then
    THEME="echelon"
    echo "No theme set. Using default '$THEME' configurations..."
else
    # check for provided theme
    if [[ ! " ${themes[*]} " =~ " $THEME " ]]; then
        echo "Error: Unknown theme '$THEME'."
        echo "Available themes: ${themes[*]}"
        exit 1
    fi
fi

CONFIG_DIR=$(echo $XDG_CONFIG_HOME)
if [ -z "$CONFIG_DIR" ]; then
    CONFIG_DIR="$HOME/.config"
fi

#======(VARIABLES)======#

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
export DEVICE_TYPE="${PROFILE%%/*}"
export PROFILE_VARIANT="${PROFILE#*/}"
export THEME=$THEME
export LAPTOP=$LAPTOP
export EDIT_USE=$EDIT_USE
export SKIP_BACKUPS=$SKIP_BACKUPS
export CONFIG_DIR=$CONFIG_DIR

# ------ paths
export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export REPO_DIR="$(dirname "$SCRIPT_DIR")"
export PROFILE_DIR=$PROFILE_DIR
export PROFILE_BASE_DIR="$REPO_DIR/profiles/$DEVICE_TYPE"

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

# ------ common functions
for script in "$REPO_DIR/scripts/functions/"*; do
    source "$script"
done

#===============================#
#          MAIN SCRIPT          #
#===============================#

#======(DEPS)======#

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

#======(BASE)======#

# --------------- git config
echo "First things first, lets make sure Git is configured"
$REPO_DIR/scripts/base_pkgs/git.sh
echo -e "\n"

# --------------- Base system packages before moving to profile specific
echo "Installing base system packages..."
$REPO_DIR/scripts/base_pkgs/system_packages.sh
echo -e "\n"

echo "Installing CLI tools..."
$REPO_DIR/scripts/base_pkgs/cli.sh
echo -e "\n"

echo "Adding services..."
$REPO_DIR/scripts/base_pkgs/services.sh
echo -e "\n"

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
$REPO_DIR/scripts/base_pkgs/shells.sh
echo -e "\n"

#======(PROFILE SPECIFIC)======#

echo "Lets begin installing the base packages for your $DEVICE_TYPE device..."
echo -e "\n"
$PROFILE_BASE_DIR/scripts/base.sh
echo -e "\n"
