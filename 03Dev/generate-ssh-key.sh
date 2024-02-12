#!/bin/bash

if [[ ! -x $(which figlet) ]]; then
    echo "This script uses Figlet. Install it before continuing..."
    exit 1
fi

if [[ ! -x $(which gum) ]]; then
    echo "This script uses Gum. Install it before continuing..."
    echo "Try running install-charm-tools."
    exit 1
fi

gum style \
	--border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
  --foreground "#9e53bc" \
  "$(figlet SSH)" \
  "$(figlet Keygen)"

if [[ ! -x $(which xclip) ]]; then
    gum -sl info "Xclip is not installed. Installing it..."
    if [ -f "/etc/os-release" ]; then
        source /etc/os-release
        case $ID in
            "ubuntu")
                sudo apt install -y xclip
                ;;
            "arch")
                sudo pacman -Syu xclip --noconfirm
                ;;
            *)
                gum -sl error "Get out of here with that shit distro!!"
                exit 1
        esac
    else
        gum -sl error "What on earth are you even using? Get out of here!!"
        exit 1
    fi
fi

gum style --foreground "#9e53bc" "Enter the name for your ssh key:"
SSH_KEY_NAME=$(gum input --placeholder "Default: id_rsa")

# If user simply pressed Enter, use the default path
if [ -z "${SSH_KEY_NAME}" ]; then
    SSH_KEY_NAME="id_rsa"
fi

SSH_KEY_PATH="$HOME/.ssh/$SSH_KEY_NAME"

# Generate the SSH Key
ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH"

# Get the public key path
SSH_KEY_PUB="${SSH_KEY_PATH}.pub"

xclip -selection clipboard < "${SSH_KEY_PUB}"
echo "SSH public key copied to clipboard!"
echo "You can configure your github and gitlab accounts using the links below:"
gum style --foreground "#539BF5" --underline \
    "https://github.com/settings/keys" \
    "https://gitlab.com/-/profile/keys"
