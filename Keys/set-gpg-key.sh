#!/bin/bash

# Function to install xclip if not present
install_xclip() {
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
}

# Ensure xclip is installed
install_xclip

# Generate GPG Key (this process might require user interaction)
gpg --full-generate-key

# After key generation, get the key ID
KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | grep sec | awk '{print $2}' | cut -d '/' -f2)

# Extract and copy the public key to clipboard
gpg --armor --export $KEY_ID | xclip -selection clipboard
echo "GPG public key copied to clipboard!"
