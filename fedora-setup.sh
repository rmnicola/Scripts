#!/usr/bin/bash

# >> dnf configuration
read -p "-- Do you wish to configure dnf? [y/N] -> " DNF_OPTION
if [ "${DNF_OPTION,,}" = "y" ] ; then dnf-setup.sh; fi

# >> update system packages
read -p "-- Update system (this may take a few minutes)? [y/N] -> " UPDATE_OPTION
if [ "${UPDATE_OPTION,,}" = "y" ] ; then sudo dnf -y update; fi

# >> download and configure zsh
read -p "-- Download and configure zsh? [y/N] -> " ZSH_OPTION
if [ "${ZSH_OPTION,,}" = "y" ] ; then zsh-setup.sh; fi

# >> fixing xdg base dir mess
read -p "-- Fix XDG Base directory mess? [y/N] -> " XDG_OPTION
if [ "${XDG_OPTION,,}" = "y" ] ; then xdg-dirs-setup.sh; fi

# >> configuring github access
read -p "-- Configure github access? [y/N] -> " GIT_OPTION
if [ "${GIT_OPTION,,}" = "y" ] ; then git-setup.sh; fi

