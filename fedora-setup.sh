#!/usr/bin/bash

# Grab script dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Require sudo
source $SCRIPT_DIR/require-sudo.sh

# >> dnf configuration
read -p "-- Do you wish to configure dnf? [y/N] -> " DNF_OPTION
if [ "${DNF_OPTION,,}" = "y" ] ; then $SCRIPT_DIR/dnf-setup.sh; fi

# >> update system packages
read -p "-- Update system (this may take a few minutes)? [y/N] -> " UPDATE_OPTION
if [ "${UPDATE_OPTION,,}" = "y" ] ; then dnf -y update; fi

# >> download and configure zsh
read -p "-- Download and configure zsh? [y/N] -> " ZSH_OPTION
if [ "${ZSH_OPTION,,}" = "y" ] ; then $SCRIPT_DIR/zsh-setup.sh; fi

# >> fixing xdg base dir mess
read -p "-- Fix XDG Base directory mess? [y/N] -> " XDG_OPTION
if [ "${XDG_OPTION,,}" = "y" ] ; then $SCRIPT_DIR/xdg-dirs-setup.sh; fi

# >> configuring git options
read -p "-- Configure git global options? [y/N] -> " GIT_OPTION
if [ "${GIT_OPTION,,}" = "y" ] ; then sudo -u $SUDO_USER $SCRIPT_DIR/git-setup.sh; fi

# >> configuring github access
read -p "-- Configure github access [y/N] -> " GITHUB_OPTION
if [ "${GITHUB_OPTION,,}" = "y" ] ; then 
	dnf install -y xclip
	sudo -u $SUDO_USER $SCRIPT_DIR/github-setup.sh ed25519
fi
