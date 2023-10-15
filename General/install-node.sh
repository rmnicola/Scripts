#!/bin/bash

# Check if 'fnm' command is available
if ! command -v fnm &> /dev/null; then
    echo "fnm is not installed. Installing now..."
    curl -fsSL https://fnm.vercel.app/install | bash
    
    # Detect the shell in use
    current_shell=$(basename $SHELL)
    if [ "$current_shell" == "zsh" ]; then
        # Check for the existence of the Dotfiles/zsh directory
        if [ -d "$HOME/Dotfiles/zsh" ]; then
            source "$HOME/Dotfiles/zsh/zshrc"
        else
            # Fallback to the standard zshrc location
            if [ -n "$ZDOTDIR" ]; then
                source "$ZDOTDIR/.zshrc"
            else
                source "$HOME/.zshrc"
            fi
        fi
    elif [ "$current_shell" == "bash" ]; then
        source ~/.bashrc
    else
        echo "Unsupported shell detected. Please manually source your shell's configuration file to use 'fnm'."
    fi
else
    echo "fnm is already installed."
fi

# Use 'fnm' to install latest version of Node.js
fnm install --lts
echo "Node.js has been installed via fnm."
node --version
