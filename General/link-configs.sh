#!/bin/bash

# Loop through every item in the current directory
for item in *; do
    # If it's a directory, check if the symlink already exists in ~/.config
    if [ -d "$item" ]; then
        # Check if the symlink already exists
        if [ ! -L "$HOME/.config/$item" ] && [ ! -d "$HOME/.config/$item" ]; then
            echo "Creating symlink for directory $item to ~/.config/$item"
            ln -s "$(pwd)/$item" "$HOME/.config/$item"
        else
            echo "Symlink or directory $item already exists in ~/.config, skipping..."
        fi

    # Special rule for logid.cfg
    elif [ "$item" == "logid.cfg" ]; then
        # Check if the symlink already exists
        if [ ! -L "/etc/logid.cfg" ] && [ ! -f "/etc/logid.cfg" ]; then
            echo "Creating symlink for file $item to /etc/logid.cfg"
            sudo ln -s "$(pwd)/$item" "/etc/logid.cfg"
        else
            echo "Symlink or file logid.cfg already exists in /etc, skipping..."
        fi
    fi
done

echo "Symlinking complete!"
