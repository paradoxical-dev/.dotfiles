#!/bin/bash

#=============================================================#
#  This file stores all functions deemed 'utility functions'  #
#     When called within the main scirpt the following        #
#      functions will be sourced and used throughout          #
#=============================================================#

# Query package list or command existance
# ---
# @param {string} command
pkg_exists() {
    qlist -I "$1" &> /dev/null || command -v "$1" &> /dev/null
}

# Copy directories or files accordingly; creating dirs when needed
# ---
# @param {string} path to source file/dir
# @param {string} path to destination file/dir
dynamic_copy() {
    local source="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"
    if [ -d "$source" ]; then
        cp -r "$source" "$dest"
    else
        cp "$source" "$dest"
    fi
}

# Handle cases where backups may be necessary
# ---
# @param {string} package name
# @param {string} path to potential user config file
# @param {string} path to the stored config file
handle_backups(){
    # skip backups if flag provided
    if [ $SKIP_BACKUPS -eq 0 ]; then
        return 0
    fi

    local pkg="$1"
    local conf_path="$2"
    local dot_file="$3"

    if [[ ! -z "$conf_path" ]]; then

        # handle multiple paths
        local config_exists=1
        for path in $conf_path; do
            if [[ -e "$path" ]]; then
                config_exists=0
            fi
        done

        if [ $config_exists -eq 0 ]; then

            # callback to handle the users backup preference
            cb() {
                local selection="$1"
                case "$selection" in
                    "Move config to .bak")
                        mv "$conf_path" "$conf_path.bak"; 
                        echo -e "$green Backup complete"
                        echo "Copying config file $dot_file to $conf_path"
                        dynamic_copy "$dot_file" "$conf_path"
                        ;;
                    "Overwrite config")
                        echo -e "${orange}Overwriting config file at $conf_path with $dot_file...${color_end}"
                        if [[ -d "$conf_path" ]]; then
                            rm -r "$conf_path"
                        fi
                        dynamic_copy "$dot_file" "$conf_path"
                        ;;
                    "Skip")
                        echo "Skipping configuration of $pkg"
                        ;;
                esac
            }

            # prompt user with backup options
            local choices=("Move config to .bak" "Overwrite config" "Skip")
            local prompt="Config file found for $pkg. Next steps?"
            choose_one "$prompt" cb "${choices[@]}"

            # remove `cb` func from global scope
            unset -f cb

        elif [[ ! -z "$dot_file" && -e $dot_file ]]; then
            # continue config if no user config present and stored config exists
            echo "Copying config file $dot_file to $conf_path..."
            dynamic_copy "$dot_file" "$conf_path"
            fi
        else
            echo "No config file required for $pkg"
        fi
    }

# Add service to open-rc default and start in current session
# ---
# @param (string) service name
add_service() {
    local name="$1"
    local desired_level="$2"

    # check if service is already added
    local run_level=$(rc-update show | awk -v svc="$name" '$1 == svc { print $3 }')
    if [[ "$run_level" == "$desired_level" ]]; then
        echo "$name already at run level $desired_level"
        return 0
    fi

    echo -e "${cyan}Starting service $name and adding to $desired_level${color_end}"
    sudo rc-service "$name" start
    sudo rc-update add "$name" "$desired_level"
}

# Prompt the user to unmask package with given keyword(s)
# ---
# @param {string} package name
# @param {list | string} keywords
# @param {string} emerge package name 
unmask_package() {
    local pkg="$1"
    local keywords="$2"
    local pkg_repo="$3"

    echo -e "$orange}The package $pkg is currently masked by keyword(s) $keywords${color_end}"

    gum_confirm "Unmask package $1?" 
    local res=$?

    if [ $res -eq 0 ]; then
        echo "$pkg_repo $keywords" | sudo tee -a "/etc/portage/package.accept_keywords/$pkg" > /dev/null
        sudo emerge --ask --noreplace "$pkg_repo"
    else
        echo "Skipping installation of $pkg"
    fi
}


# Edit per package USE when applicable
# ---
# @param (string) package name
# @param (string) package repo name
# @param (string | list) available flags
edit_use() {
    # return if no-edit-use flag is present
    if [ "$EDIT_USE" -eq 1 ]; then
        return 0
    fi

    local pkg="$1"
    local pkg_repo="$2"
    shift 2
    local flags="$@"

    # parse and display the current flags applied to the pacakge
    local use=$(emerge -pv "$pkg_repo" | grep "$pkg_repo")
    local default_flags=$(echo "$use" | sed -n 's/.*USE="\([^"]*\)".*/\1/p')
    echo -e "${cyan}The following are the default flags $pkg will be installed with${color_end}"
    echo -e "\n"
    echo "$default_flags"
    echo -e "\n"

    # mark flags to include
    local added_flags=()
    cb() {
        local flag="$1"
        added_flags+=("$flag")
        echo -e "Including flag $flag"
    }
    choose_multi "Choose which flags to ADD at build time" cb $flags
    unset -f cb

    echo -e "\n"

    # mark flags for removal
    local removed_flags=()
    cb() {
        local flag="$1"
        removed_flags+=("$flag")
        echo -e "Removing flag $flag"
    }
    choose_multi "Choose which flags to REMOVE at build time" cb $flags
    unset -f cb

    # create master string to include in package.use file
    if [ ${#removed_flags[@]} -eq 0 ]; then
        local r=" "    
    else
        local r=$(printf -- '-%s ' "${removed_flags[@]}")
    fi
    local a=$(printf -- '%s ' "${added_flags[@]}")
    # remove trailing whitespace
    r=${r::-1}
    a=${a::-1}

    gum_confirm "Confirm thr following modifications: $r $a"
    local confirm=$?

    if [ $confirm -eq 0 ]; then
        echo -e "${yellow}Copying flag modifications to /etc/portage/package.use/$pkg${color_end}..."
        echo "$pkg_repo $a $r" | sudo tee "/etc/portage/package.use/${pkg}" > /dev/null
        echo -e "\n"
        echo -e "${green}Successfully added custom USE to $pkg${color_end}"
    else
        echo -e "${yellow}Resetting selection...${color_end}"
        edit_use
    fi
}

export -f pkg_exists
export -f dynamic_copy
export -f handle_backups
export -f add_service
export -f unmask_package
export -f edit_use
