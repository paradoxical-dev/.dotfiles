#!/bin/bash

# INFO: This is the main file called to consolidate hardware related packages

HARDWARE_PATH="$PROFILE_BASE_DIR/scripts/hardware/"

echo "Installing wireless packages..."
$HARDWARE_PATH/wireless.sh
echo -e "\n"

echo "Installing pipewire for audio and video..."
$HARDWARE_PATH/pipewire.sh
echo -e "\n"

# echo "Installing packages for bluetooth functionality..."
# $HARDWARE_PATH/bluetooth.sh
