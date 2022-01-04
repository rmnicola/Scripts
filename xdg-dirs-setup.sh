#!/usr/bin/bash

# Grab script dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Require sudo
source $SCRIPT_DIR/require-sudo.sh

declare HISTFILE_CONF='export HISTFILE=$XDG_STATE_HOME/bash/history'
declare ZSH_ENV_PATH="/etc/zshenv"

echo ">> Cleaning up bash files."
deescalate mkdir -p "$XDG_STATE_HOME"/bash
if ! grep -Fxq "$HISTFILE_CONF" $ZSH_ENV_PATH ; then
	echo ">>>> Adding HISTFILE env variable."
	echo "$HISTFILE_CONF" | tee -a $ZSH_ENV_PATH > /dev/null
else
	echo ">>>> HISTFILE env variable already set."
fi

echo ">>>> Cleaning up bash dotfiles."
deescalate rm $HOME/.bash* 2> /dev/null

echo ">> Cleaning up git files."
echo ">>>> Creating config folder for git."
deescalate mkdir -p "$XDG_CONFIG_HOME"/git
echo ">>>> Sending existing git config to the proper location"
deescalate mv "$HOME"/.gitconfig "$XDG_CONFIG_HOME"/git/config 2> /dev/null

echo ">> Cleaning up less files." 
deescalate rm $HOME/.less* 2> /dev/null


