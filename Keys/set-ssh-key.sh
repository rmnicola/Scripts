#!/bin/bash

# Generate SSH Key
ssh-keygen -t rsa -b 4096

# Check for IP/hostname argument
if [ "$1" ]; then
    ssh-copy-id "$1"
else
    # Check if xclip is installed
    which xclip &>/dev/null
    if [ $? -ne 0 ]; then
        # Check if the system is Ubuntu or Arch
        if [ -f "/etc/os-release" ]; then
            source /etc/os-release
            if [ "$ID" == "ubuntu" ]; then
                sudo apt update
                sudo apt install -y xclip
            elif [ "$ID" == "arch" ]; then
                sudo pacman -Syu xclip --noconfirm
            else
                echo "Unsupported OS. Install xclip manually."
                exit 1
            fi
        else
            echo "Unable to determine OS. Install xclip manually."
            exit 1
        fi
    fi

    # Copy SSH public key to clipboard
    xclip -selection clipboard < ~/.ssh/id_rsa.pub
    echo "SSH public key copied to clipboard!"
fi
