#!/bin/bash

inform_msg "WARNING" "It is highly recommended to add the 'networkmanager' USE flag globally to allow other networkmanager in other packages"
sleep 3

#---------- define available USE flags
flags=(
    ""
)

gum_confirm "Would you like to edit the USE flags for networkmanager?"
update_use=$?
