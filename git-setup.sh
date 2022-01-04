#!/usr/bin/bash

echo ">> Configuring git global options."

# Configuring github access
echo ">>>> Setting up global git configs."
read -p "-- Enter your full name: " FNAME
git config --global user.name "$FNAME"
read -p "-- Enter your email address (same as github): " EMAIL
git config --global user.email "$EMAIL"
echo ">>>> Setting neovim as the main git editor."
git config --global core.editor nvim

