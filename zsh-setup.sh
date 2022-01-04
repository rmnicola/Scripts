#!/usr/bin/bash

echo ">> Downloading and configuring zsh."

# Set global zshenv path
declare ZSH_ENV_PATH="/etc/zshenv"

# Set location for zsh's conf folder
declare ZDOTDIR_CONF="export ZDOTDIR=$HOME/.config/zsh"

echo ">>>> Installing zsh."
sudo dnf -y install zsh

echo ">>>> Changing default shell to zsh."
sudo -u $USERNAME chsh -s $(which zsh) 2> /dev/null

echo ">>>> Configuring global zshenv."
if ! grep -Fxq "$ZDOTDIR_CONF" $ZSH_ENV_PATH ; then
	echo ">>>>>> Adding ZDOTDIR env variable."
	echo "$ZDOTDIR_CONF" | sudo tee -a $ZSH_ENV_PATH > /dev/null
else
	echo ">>>>>> ZDOTDIR already configured."
fi

echo ">>>> Grabbing configuration files from remote repo"
rm -rf $HOME/Dotfiles
git clone --recurse-submodules https://github.com/rmnicola/Dotfiles $HOME/Dotfiles

echo ">>>> Creating symlink to zsh config folder."
ln -sfvT $HOME/Dotfiles/zsh $ZDOTDIR

