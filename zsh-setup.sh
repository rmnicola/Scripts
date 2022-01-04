#!/usr/bin/bash

# Grab script dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Require sudo
source $SCRIPT_DIR/require-sudo.sh

echo ">> Downloading and configuring zsh."

# Set global zshenv path
declare ZSH_ENV_PATH="/etc/zshenv"

# Set location for zsh's conf folder
declare ZDOTDIR_CONF="export ZDOTDIR=/home/$SUDO_USER/.config/zsh"

echo ">>>> Installing zsh."
dnf -y install zsh

echo ">>>> Changing default shell to zsh."
deescalate chsh -s $(which zsh) 2> /dev/null

echo ">>>> Configuring global zshenv."
if ! grep -Fxq "$ZDOTDIR_CONF" $ZSH_ENV_PATH ; then
	echo ">>>>>> Adding ZDOTDIR env variable."
	echo "$ZDOTDIR_CONF" | tee -a $ZSH_ENV_PATH > /dev/null
else
	echo ">>>>>> ZDOTDIR already configured."
fi

echo ">>>> Grabbing configuration files from remote repo"
deescalate rm -rf $HOME/Dotfiles
deescalate git clone --recurse-submodules \
	https://github.com/rmnicola/Dotfiles $HOME/Dotfiles

echo ">>>> Creating symlink to zsh config folder."
deescalate ln -sfvT $HOME/Dotfiles/zsh $ZDOTDIR

