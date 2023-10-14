#!/bin/bash

# Function to ensure xclip is installed
ensure_xclip() {
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

# Prompt user for the SSH key path
echo "Enter file in which to save the key (/home/username/.ssh/id_rsa): "
read SSH_KEY_PATH

# If user simply pressed Enter, use the default path
if [ -z "${SSH_KEY_PATH}" ]; then
    SSH_KEY_PATH="$HOME/.ssh/id_rsa"
fi

# Generate the SSH Key
ssh-keygen -t rsa -b 4096 -f "${SSH_KEY_PATH}"

# Get the public key path
SSH_KEY_PUB="${SSH_KEY_PATH}.pub"

# Check for IP/hostname argument
if [ "$1" == "git" ]; then
    echo "Configuring git to use SSH key for signing commits..."
    git config --global gpg.format ssh
    echo "Setting user.signingkey to ${SSH_KEY_PUB}"
    git config --global user.signingkey "${SSH_KEY_PUB}"
    echo "Enabling commit.gpgsign..."
    git config --global commit.gpgsign true
    echo "Configuring git to use SSH for GitHub repositories..."
    git config --global url."git@github.com:".insteadOf "https://github.com/"
    echo "Git configuration completed!"
elif [ "$1" ]; then
    ssh-copy-id "$1"
fi

ensure_xclip
xclip -selection clipboard < "${SSH_KEY_PUB}"
echo "SSH public key copied to clipboard!"
