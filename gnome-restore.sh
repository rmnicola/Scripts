#!/bin/bash

# Check if there is input from stdin
if [ -t 0 ]; then
  echo "Error: Please provide the backup file as stdin input."
  echo "Usage: cat backup_file.txt | $0"
  exit 1
fi

# Restore the GNOME configurations from the backup file
dconf reset -f /
dconf load / < /dev/stdin

# Print a message indicating that the restore is complete
echo "GNOME configuration restore complete."
