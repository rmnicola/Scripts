#!/usr/bin/bash

echo ">> Configuring git global options."

# Configuring github access
echo ">>>> Setting up global git configs."
read -p "-- Enter your full name: " FNAME
git config --global user.name "$FNAME"
read -p "-- Enter your email address (from github): " EMAIL
git config --global user.email "$EMAIL"
echo ">>>> Setting neovim as the main git editor."
git config --global core.editor nvim

echo ">> Configuring github access."
read -p "-- Enter the name for your private key: " SSH_KEYNAME
echo ">>>> Generating keypair."
ssh-keygen -t ed25519 -C "$EMAIL" -f "$HOME"/.ssh/"$SSH_KEYNAME"
echo ">>>> Restarting ssh agent."
ssh-agent sh -c "ssh-add "$HOME"/.ssh/"$SSH_KEYNAME""
echo ">>>> Installing xclip."
sudo dnf -y install xclip
echo ">>>> Copying ssh public key to your keyboard."
cat "$HOME"/.ssh/"$SSH_KEYNAME".pub | xclip -sel clip 
read -p ">>> YOUR PUBLIC KEY HAS BEEN ADDED TO YOUR CLIPBOARD, COPY IT INTO 
GITHUB (https://github.com/settings/keys) AND PRESS ANY KEY TO CONTINUE <<<"
echo ">>>> Testing connection to github.com."
ssh -T git@github.com
