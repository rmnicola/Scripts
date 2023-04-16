#!/bin/bash

# Display help message if backup file is not specified
if [ -z "$1" ]; then
  echo "Please specify the backup file location as the first argument."
  exit 1
fi

# Use dconf dump to create a backup of all GNOME configurations
dconf dump / > "$1"

# Print a message indicating that the backup is complete
echo "GNOME configuration backup complete. Backup file location: $1"
