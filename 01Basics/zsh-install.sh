#!/bin/bash

# Function to detect the distribution
detect_distribution() {
    if grep -q 'ID=ubuntu' /etc/os-release || grep -q 'ID=debian' /etc/os-release; then
        echo "ubuntu"
    elif grep -q 'ID=arch' /etc/os-release; then
        echo "arch"
    else
        echo "unknown"
    fi
}

# Determine which package manager to use based on distribution
install_zsh() {
    local distro=$1

    case "$distro" in
        ubuntu)
            sudo apt update
            sudo apt install -y zsh
            ;;
        arch)
            sudo pacman -Syu --noconfirm zsh
            ;;
        *)
            echo "Unsupported distribution. Exiting."
            exit 1
            ;;
    esac
}

# 1. Detect distribution and install zsh
distro=$(detect_distribution)
install_zsh "$distro"

# 2. Set zsh as the default shell for the current user
chsh -s $(which zsh)

# 3. Define lines to be added to /etc/zsh/zshenv
declare -A LINES=(
    ["ZDOTDIR"]="$HOME/.config/zsh"
    ["XDG_CACHE_HOME"]="$HOME/.cache"
    ["XDG_CONFIG_HOME"]="$HOME/.config"
    ["XDG_DATA_HOME"]="$HOME/.local/share"
    ["XDG_RUNTIME_DIR"]="/run/user/$UID"
    ["XDG_CONFIG_DIRS"]="/etc/xdg"
)

# Check and append each line to /etc/zsh/zshenv if it doesn't already exist
for VAR in "${!LINES[@]}"; do
    LINE="${VAR}=${LINES[$VAR]}"
    if ! grep -qxF "$LINE" /etc/zsh/zshenv; then
        echo "$LINE" | sudo tee -a /etc/zsh/zshenv > /dev/null
        echo "Added $LINE to /etc/zsh/zshenv."
    else
        echo "$LINE already exists in /etc/zsh/zshenv."
    fi
done

# Start zsh in the current session
zsh

printf "Zsh is now configured and active in this terminal session. 
The changes will become permanent when you reboot your system."
