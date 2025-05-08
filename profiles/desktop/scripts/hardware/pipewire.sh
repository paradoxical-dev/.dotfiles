#!/bin/bash

if pkg_exists "pipewire"; then
    echo -e "${green}pipewire already installed${color_end}"
    exit 0
fi

flags=(
    "man"
    "X"
    "bluetooth"
    "dbus"
    "doc"
    "echo-cancel"
    "elogind"
    "extra"
    "ffmpeg"
    "flatpak"
    "gsettings"
    "gstreamer"
    "ieee1394"
    "jackclient"
    "jack-sdk"
    "liblc3"
    "loudness"
    "lv2"
    "modemmanager"
    "pipewire-alsa"
    "readline"
    "roc"
    "selinux"
    "sound-server"
    "ssl"
    "system-service"
    "systemd"
    "test"
    "v4l"
    "zeroconf"
)

#----------- handle USE flag modifications
gum_confirm "Would you like to edit the USE flags for pipewire?"
update_use=$?
echo -e "\n"

if [ $update_use -eq 0 ]; then
   echo -e "${cyan}Here is your current global USE flags for reference:${color_end}" 
   emerge --info | grep ^USE=
   echo -e "\n"
   edit_use "pipewire" "media-video/pipewire" "${flags[@]}"
else
    echo -e "Skipping USE modifications..."
    echo -e "\n"
fi

sudo emerge --ask "media-video/pipewire"
echo -e "\n"

#----------- add user to pipewire
user=$(whoami)
echo "Adding current user $user to 'pipewire' group..."
sudo usermod -aG pipewire "$user"
