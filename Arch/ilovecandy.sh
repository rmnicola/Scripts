#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Please run with sudo." 
   exit 1
fi

# Save a backup copy of the original file
cp /etc/pacman.conf /etc/pacman.conf.bak

# Use sed to uncomment the "ParallelDownloads" line
sed -i 's/^#ParallelDownloads\s*=\s*5/ParallelDownloads = 5/' /etc/pacman.conf

# Use sed to uncomment the "Color" line
sed -i 's/^#Color$/Color/' /etc/pacman.conf

# Check if the "ILoveCandy" line already exists in the file
if ! grep -q '^ILoveCandy$' /etc/pacman.conf; then
    # Use sed to add the "ILoveCandy" line after the "ParallelDownloads" line
    sed -i '/^ParallelDownloads\s*=\s*5/a ILoveCandy' /etc/pacman.conf
fi
