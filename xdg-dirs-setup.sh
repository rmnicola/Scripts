#!/usr/bin/bash

declare HISTFILE_CONF="export HISTFILE="$XDG_STATE_HOME"/bash/history"
declare ZSH_ENV_PATH="/etc/zshenv"

echo ">> Cleaning up bash files."
mkdir -p "$XDG_STATE_HOME"/bash
if ! grep -Fxq "$HISTFILE_CONF" $ZSH_ENV_PATH ; then
	echo ">>>> Adding HISTFILE env variable."
	echo "$HISTFILE_CONF" | sudo tee -a $ZSH_ENV_PATH > /dev/null
else
	echo ">>>> HISTFILE env variable already set."
fi
echo ">>>> Cleaning up bash dotfiles."
rm $HOME/.bash* 2> /dev/null

echo ">> Cleaning up git files."
echo ">>>> Creating config folder for git."
mkdir -p "$XDG_CONFIG_HOME"/git
echo ">>>> Sending existing git config to the proper location"
mv "$HOME"/.gitconfig "$XDG_CONFIG_HOME"/git/config 2> /dev/null

echo ">> Cleaning up less files." 
rm $HOME/.less* 2> /dev/null


