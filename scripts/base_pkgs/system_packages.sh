#!/bin/bash

pkg_list=(
    "libnotify"
    "parallel"
    "ripgrep"
    "unzip"
    "upower"
)

declare -A pkg_name_map
pkg_name_map["libnotify"]="x11-libs/libnotify"
pkg_name_map["parallel"]="sys-process/parallel"
pkg_name_map["ripgrep"]="sys-apps/ripgrep"
pkg_name_map["unzip"]="app-arch/unzip"
pkg_name_map["upower"]="sys-power/upower"

for pkg in $pkg_list; do
    pkg_name="${pkg_name_map["$pkg"]}"
    echo "Installing $pkg..."
    sudo emerge --ask --noreplace $pkg_name
done
