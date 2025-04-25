#!/bin/bash

pkg_list=(
    "breeze-icons"
    "hyprland"
    "hyprpaper"
    "hyprpolkit"
    "wayland"
    "wl-clipboard"
    "wlroots"
    "xdg-desktop-portal"
    "xdg-desktop-portal-gtk"
    "xdg-desktop-portal-hyprland"
    "xwayland"
)

# ------------- map packages to their config files
declare -A conf_path_map
conf_path_map["hyprland"]="$CONFIG_DIR/hypr"
conf_path_map["hyprpaper"]="$CONFIG_DIR/hypr/hyprpaper.conf"

# -------------- map packages to their repo names
declare -A pkg_name_map
pkg_name_map["breeze-icons"]="kde-frameworks/breeze-icons"
pkg_name_map["hyprland"]="gui-wm/hyprland"
pkg_name_map["hyprpaper"]="gui-apps/hyprpaper"
pkg_name_map["hyprpolkit"]="sys-auth/hyprpolkitagent"
pkg_name_map["wayland"]="dev-libs/wayland"
pkg_name_map["wl-clipboard"]="gui-apps/wl-clipboard"
pkg_name_map["wlroots"]="gui-libs/wlroots"
pkg_name_map["xdg-desktop-portal"]="sys-apps/xdg-desktop-portal"
pkg_name_map["xdg-desktop-portal-gtk"]="sys-apps/xdg-desktop-portal-gtk"
pkg_name_map["xdg-desktop-portal-hyprland"]="gui-libs/xdg-desktop-portal-hyprland"
pkg_name_map["xwayland"]="x11-base/xwayland"

# -------------- map dotfiles to package names
declare -A pkg_conf_map
pkg_conf_map["hyprland"]="$HOME/.dotfiles/profiles/desktop/hypr/hypr_conf/"
pkg_conf_map["hyprpaper"]="$HOME/.dotfiles/profiles/desktop/hypr/hypr_conf/hyprpaper.conf"
