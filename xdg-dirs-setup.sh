#!/usr/bin/bash

# Grab script dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Require sudo
source $SCRIPT_DIR/require-sudo.sh

declare HISTFILE_CONF='export HISTFILE=$XDG_STATE_HOME/bash/history'
declare ZSH_ENV_PATH="/etc/zshenv"

echo ">> Cleaning up bash files."
deescalate_user mkdir -p /home/$SUDO_USER/.local/state/bash
if ! grep -Fxq "$HISTFILE_CONF" $ZSH_ENV_PATH ; then
	echo ">>>> Adding HISTFILE env variable."
	echo "$HISTFILE_CONF" | tee -a $ZSH_ENV_PATH > /dev/null
else
	echo ">>>> HISTFILE env variable already set."
fi

echo ">>>> Cleaning up bash dotfiles."
deescalate_user rm -v /home/$SUDO_USER/.bash* 

echo ">> Cleaning up git files."
echo ">>>> Creating config folder for git."
deescalate_user mkdir -p /home/$SUDO_USER/.config/git
echo ">>>> Creating config file for git."
deescalate_user touch /home/$SUDO_USER/.config/git/config
echo ">>>> Sending existing git config to the proper location"
deescalate_user mv /home/$SUDO_USER/.gitconfig /home/$SUDO_USER/.config/git/config 

echo ">> Cleaning up less files." 
deescalate_user rm -v /home/$SUDO_USER/.less*


