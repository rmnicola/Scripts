#!/usr/bin/bash

# Grab script dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Require sudo
source $SCRIPT_DIR/require-sudo.sh

# >> dnf configuration
read -p "-- Do you wish to configure dnf? [y/N] -> " DNF_OPTION
if [ "${DNF_OPTION,,}" = "y" ] ; then $SCRIPT_DIR/dnf-setup.sh; fi

# >> update system packages
read -p "-- Update system (will take a few minutes)? [y/N] -> " UPDATE_OPTION
if [ "${UPDATE_OPTION,,}" = "y" ] ; then dnf update; fi

# >> download programs from applist.txt
read -p "-- Install software from applist.txt? [y/N] -> " INSTALL_OPTION
if [ "${INSTALL_OPTION,,}" = "y" ] ; then $SCRIPT_DIR/software-install.sh; fi

# >> Configure zsh
read -p "-- Configure zsh? [y/N] -> " ZSH_OPTION
if [ "${ZSH_OPTION,,}" = "y" ] ; then $SCRIPT_DIR/zsh-setup.sh; fi

read -p "-- Set up dotfiles? [y/N] -> " DOT_OPTION
if [ "${DOT_OPTION,,}" = "y" ] ; then $SCRIPT_DIR/dotfiles-setup.sh; fi

# >> fixing xdg base dir mess
read -p "-- Fix XDG Base directory mess? [y/N] -> " XDG_OPTION
if [ "${XDG_OPTION,,}" = "y" ] ; then $SCRIPT_DIR/xdg-dirs-setup.sh; fi

# >> configuring git options
read -p "-- Configure git global options? [y/N] -> " GIT_OPTION
if [ "${GIT_OPTION,,}" = "y" ] ; then 
  deescalate_user $SCRIPT_DIR/git-setup.sh
fi

# >> configuring github access
read -p "-- Configure github access? [y/N] -> " GITHUB_OPTION
if [ "${GITHUB_OPTION,,}" = "y" ] ; then 
	deescalate_user $SCRIPT_DIR/github-setup.sh ed25519
fi

# >> configure rclone
read -p "-- Configure rclone? [y/N] -> " RCLONE_OPTION
if [ "${RCLONE_OPTION,,}" = "y" ] ; then 
	$SCRIPT_DIR/rclone-setup.sh
  read -p ">> Checking rclone config. Press any key to continue..."
	deescalate_user rclone config
fi

# >> Grab system backup
read -p "-- Download and restore gnome backup? [y/N] -> " SYS_BKP_OPTION
if [ "${SYS_BKP_OPTION,,}" = "y" ] ; then 
	deescalate_user rclone copy --drive-chunk-size 512M --max-backlog 999999 \
	--fast-list -v --checkers 5 --transfers 30 --stats 30s \
	gdrive-crypto:backup/.backup /home/$SUDO_USER/Documents/.backup
fi

# >> Grab documents backup
read -p "-- Download and restore documents folder? [y/N] -> " DOC_BKP_OPTION
if [ "${DOC_BKP_OPTION,,}" = "y" ] ; then 
	deescalate_user rclone copy --drive-chunk-size 512M --max-backlog 999999 \
	--fast-list -v --checkers 5 --transfers 30 --stats 30s \
	gdrive-crypto:backup /home/$SUDO_USER/Documents
fi
