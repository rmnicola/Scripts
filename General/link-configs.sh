#!/bin/bash

# Loop through every item in the current directory
for item in *; do
    # If it's a directory, symlink to ~/.config
    if [ -d "$item" ]; then
        echo "Creating symlink for directory $item to ~/.config/$item"
        ln -s "$(pwd)/$item" "$HOME/.config/$item"
    
    # Special rule for logid.cfg
    elif [ "$item" == "logid.cfg" ]; then
        echo "Creating symlink for file $item to /etc/logid.cfg"
        sudo ln -s "$(pwd)/$item" "/etc/logid.cfg"
    fi
done

echo "Symlinking complete!"
