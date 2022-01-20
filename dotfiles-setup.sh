#!/usr/bin/bash

# Grab script dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Require sudo
source $SCRIPT_DIR/require-sudo.sh

echo ">> Grabbing configuration files from remote repo"
deescalate_user git clone --recurse-submodules \
	https://github.com/rmnicola/Dotfiles /home/$SUDO_USER/Dotfiles
check_operation Clone dotfiles repo

echo ">> Running linker script."
/home/$SUDO_USER/Dotfiles/linker.sh
check_operation Linker script
