#!/bin/bash

# --------------- list of pkgs
shells=(
    "bash"
    "fish"
    "nushell"
    "zsh"
)

# --------------- map potential configuration paths to pkgs
declare -A conf_path_map


# --------------- map dotfiles to pkg names
declare -A pkg_conf_map
pkg_conf_map

# --------------- map packages to repo names
declare -A pkg_name_map
pkg_name_map["bash"]
pkg_name_map["fish"]
pkg_name_map["nushell"]
pkg_name_map["zsh"]="app-shells/zsh"


#TODO: Continue shell installation script
