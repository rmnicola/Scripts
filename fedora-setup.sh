#!/usr/bin/bash

# Configures dnf
echo ">> Configuring dnf."

declare DNF_CONF_PATH="/etc/dnf/dnf.conf"
declare -a CONF_ARRAY=("fastest_mirror=True" "max_parallel_downloads=10")
declare -i DNF_CHANGES=0

declare ZSH_ENV_PATH="/etc/zshenv"
declare ZDOTDIR_CONF="exp-ort ZDOTDIR=$HOME/.config/zsh"

# Loop every configuration and checks if it already exists
for CONF in ${CONF_ARRAY[@]}; do
	if ! grep -Fxq $CONF $DNF_CONF_PATH ; then 
		# If it does not exist, add it
		sudo sed -i "/^[main]/a $CONF" $DNF_CONF_PATH 
		echo ">> Added option $CONF!"
		let "DNF_CHANGES+=1"
	else
		echo ">> Option $CONF has already been added"
	fi
done

# Updates dnf config if there were changes
if [ $DNF_CHANGES -gt 0 ] ; then
	echo ">> Cleaning up."
	sudo dnf clean all
else
	echo ">> No changes were made, moving on."
fi

# Updates system packages
read -p "-- Update system (this may take a few minutes)? [y/N] " UPDATE_OPTION
if [ "${UPDATE_OPTION,,}" = "y" ] ; then
	sudo dnf -y update
fi

# Download and configure zsh
echo ">> Downloading and configuring zsh."
sudo dnf -y install zsh
echo ">> Changing default shell to zsh."
sudo -u $USERNAME chsh -s $(which zsh)
echo ">> Configuring global zshenv."
if ! grep -Fxq "$ZDOTDIR_CONF" $ZSH_ENV_PATH ; then
	echo ">> Adding ZDOTDIR env variable."
	echo ">> $ZDOTDIR_CONF" | sudo tee -a $ZSH_ENV_PATH > /dev/null
else
	echo ">> ZDOTDIR already configured."
fi

# Fixing XDG Base dir mess
# Bash
echo ">> Changing default (messy) locations for bash config files."
mkdir -p "$XDG_STATE_HOME"/bash
declare HISTFILE_CONF="export HISTFILE="$XDG_STATE_HOME"/bash/history"
if ! grep -Fxq "$HISTFILE_CONF" $ZSH_ENV_PATH ; then
	echo ">> Adding HISTFILE env variable."
	echo ">> $HISTFILE_CONF" | sudo tee -a $ZSH_ENV_PATH > /dev/null
else
	echo ">> HISTFILE env variable already set."
fi

# Git
echo ">> Creating config folder for git"
mkdir -p "$XDG_CONFIG_HOME"/git
echo ">> Sending existing git config to the proper location"
mv "$HOME"/.gitconfig "$XDG_CONFIG_HOME"/git/config 2> /dev/null

echo ">> Cleaning up bash dotfiles."
rm $HOME/.bash* 2> /dev/null
echo ">> Cleaning up less files." rm $HOME/.less* 2> /dev/null

# Configuring github access
echo ">> Setting up global git configs."
read -p "-- Enter your full name: " FNAME
git config --global user.name "$FNAME"
read -p "-- Enter your email address (from github): " EMAIL
git config --global user.email "$EMAIL"
echo ">> Setting neovim as the main git editor."
git config --global core.editor nvim
read -p "-- Do you wish to create a new ssh key for github access? [y/N] " SSH_OPTION
if [ ${SSH_OPTION,,} == 'y' ]; then 
	read -p ">> Enter the name for your private key: " SSH_KEYNAME
	echo ">> Generating keypair."
	ssh-keygen -t ed25519 -C "$EMAIL" -f "$HOME"/.ssh/"$SSH_KEYNAME"
	echo ">> Restarting ssh agent."
	ssh-agent sh -c "ssh-add "$HOME"/.ssh/"$SSH_KEYNAME""
	echo ">> Installing xclip."
	sudo dnf -y install xclip
	echo ">> Copying ssh public key to your keyboard."
	cat "$HOME"/.ssh/"$SSH_KEYNAME".pub | xclip -sel clip 
	read -p ">>> YOUR PUBLIC KEY HAS BEEN ADDED TO YOUR CLIPBOARD, COPY IT INTO GITHUB AND PRESS ANY KEY TO CONTINUE <<<"
	echo ">> Testing connection to github.com."
	ssh -T git@github.com
fi
