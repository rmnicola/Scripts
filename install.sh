#!/bin/bash

# Find all .sh files in the current directory that are not named install.sh
for file in $(ls *.sh | grep -v install.sh); do
    # Strip the .sh extension from the filename
    filename=$(basename "$file" .sh)

    # Create a symlink in /usr/local/bin using pkexec
    pkexec ln -s "$(pwd)/$file" "/usr/local/bin/$filename"
done
