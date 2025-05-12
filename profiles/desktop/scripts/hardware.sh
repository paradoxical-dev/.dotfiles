#!/bin/bash

# INFO: This is the main file called to consolidate hardware related packages

export HARDWARE_PATH="$PROFILE_BASE_DIR/scripts/hardware/"

echo "Installing wireless packages..."
echo -e "\n"
$HARDWARE_PATH/wireless.sh
echo -e "\n"

# TODO: Potentially need more for audio output
echo "Installing audio and video packages..."
echo -e "\n"
$HARDWARE_PATH/audio.sh
echo -e "\n"
