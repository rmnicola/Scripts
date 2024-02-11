#! /bin/bash

if [[ ! -x $(which figlet) ]]; then
    echo "This script uses Figlet. Install it before continuing..."
    exit 1
fi

if [[ ! -x $(which gum) ]]; then
    echo "This script uses Gum. Install it before continuing..."
    echo "Try running install-charm-tools."
    exit 1
fi

gum style \
	--border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
  --foreground "#9e53bc" \
  "$(figlet Git)" \
  "$(figlet Config.)"

NAME=$(gum input --placeholder "Type your full name")
git config --global user.name "$NAME"

EMAIL=$(gum input --placeholder "Type your email address")
git config --global user.email "$EMAIL"

gum style --foreground "#9e53bc" "Choose your commit editor:"
COMMIT_EDITOR=$(gum choose "Neovim" "Vscode" "Nano")
case $COMMIT_EDITOR in
    "Neovim")
        git config --global core.editor "nvim"
        ;;
    "Vscode")
        git config --global core.editor "code"
        ;;
    "Nano")
        git config --global core.editor "nano"
        ;;
esac
