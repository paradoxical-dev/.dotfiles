#!/bin/bash

echo -e "\n"
echo "Installing networkmanager for wireless support..."
echo -e "\n"
$HARDWARE_PATH/wireless/nm.sh

echo -e "\n"
echo "Installing bluez for bluetooth support..."
echo -e "\n"
$HARDWARE_PATH/wireless/bluetooth.sh
