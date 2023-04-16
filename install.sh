#!/bin/bash

# Find all .sh files in the current directory
for file in *.sh; do
    # Check if the file is not already executable
    if ! [ -x "$file" ]; then
        # Make the file executable
        chmod +x "$file"
    fi

    # Check if the filename is not "install.sh"
    if [ "$(basename "$file")" != "install.sh" ]; then
        # Strip the .sh extension from the filename
        filename=$(basename "$file" .sh)

        # Check if the file is not already symlinked to /usr/local/bin
        if ! [ -L "/usr/local/bin/$filename" ]; then
            # Create a symlink in /usr/local/bin using pkexec
            pkexec ln -s "$(pwd)/$file" "/usr/local/bin/$filename"
            echo "Symlink created for $filename"
        else
            echo "Symlink for $filename already exists"
        fi
    fi
done
