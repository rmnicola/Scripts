#! /bin/bash

if [[ ! -x $(which gum) ]]; then
    printf "This script uses Gum. Install it before continuing...
    Try running install-charm-tools."
    exit 1
fi

gum style \
	--border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'Git configuration'

NAME=$(gum input --placeholder "Github name")
git config --global user.name "$NAME"

EMAIL=$(gum input --placeholder "Github email")
git config --global user.email "$EMAIL"

gum confirm "Set nvim as the commit editor?" && git config --global core.editor "nvim"
gum confirm "Configure ssh?" && set-ssh-key git
