#!/bin/bash

# If "gdrive" is the first argument
if [ "$1" == "gdrive" ]; then
    # Download the Google Drive file using curl and load it into dconf
    curl -L "https://drive.google.com/uc?export=download&id=10Jroh7WtnzQ46-PFapr5_FrJyNG_Wf-1" --output /tmp/gdrive_backup.txt
    dconf reset -f /
    dconf load / < /tmp/gdrive_backup.txt
    rm /tmp/gdrive_backup.txt
    echo "GNOME configuration restore from Google Drive complete."
    exit 0
fi

# Check if there is input from stdin
if [ -t 0 ]; then
  echo "Error: Please provide the backup file as stdin input or use 'gdrive' option."
  echo "Usage: cat backup_file.txt | $0"
  echo "Or: $0 gdrive"
  exit 1
fi

# Restore the GNOME configurations from the backup file
dconf reset -f /
dconf load / < /dev/stdin

# Print a message indicating that the restore is complete
echo "GNOME configuration restore complete."
