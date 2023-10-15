#!/bin/bash

# Function to check if a command exists
command_exists() {
    type "$1" &> /dev/null ;
}

# If "gdrive" is the first argument
if [ "$1" == "gdrive" ]; then
    # Check if gdrive is installed
    if ! command_exists gdrive; then
        echo "gdrive is not installed. Opening the installation links in your browser..."
        xdg-open "https://github.com/glotlabs/gdrive/releases" &> /dev/null & 
        xdg-open "https://console.cloud.google.com/apis/credentials?project=rclone-rmnicola" &> /dev/null &
        exit 1
    fi

    # Temporary file to store the dconf dump
    TMP_FILE=$(mktemp)
    
    # Dump the GNOME configurations to the temp file
    dconf dump / > "$TMP_FILE"
    
    # Upload the backup to Google Drive folder with the name "backup.txt"
    gdrive files update 10Jroh7WtnzQ46-PFapr5_FrJyNG_Wf-1 "$TMP_FILE"
    
    # Delete the temporary file
    rm "$TMP_FILE"
    
    echo "GNOME configuration backup uploaded to Google Drive."
    exit 0
fi

# Display help message if backup file is not specified
if [ -z "$1" ]; then
    echo "Please specify the backup file location as the first argument or use 'gdrive' to upload to Google Drive."
    exit 1
fi

# Use dconf dump to create a backup of all GNOME configurations
dconf dump / > "$1"

# Print a message indicating that the backup is complete
echo "GNOME configuration backup complete. Backup file location: $1"
