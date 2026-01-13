#!/bin/bash

# Loop through every item in the current directory
for item in *; do
    # If it's a directory, check if the symlink already exists in ~/.config
    if [ -d "$item" ]; then
        # Check if the symlink already exists
        if [ ! -L "$HOME/.config/$item" ] && [ ! -d "$HOME/.config/$item" ]; then
            ln -s "$(pwd)/$item" "$HOME/.config/$item"
            echo "✅ $item -> ~/.config/$item"
        else
            echo "• ~/.config/$item already exists. Skipping."
        fi
done

echo "Symlinking complete!"
