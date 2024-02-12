#!/bin/bash

# Check for root permissions
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run as root, the script will ask for permissions when needed."
    exit 1
fi

# Detect OS
if cat /etc/os-release | grep -q "ID=arch"; then
    OS="ARCH"
elif cat /etc/os-release | grep -qE "ID=debian|ID=ubuntu"; then
    OS="DEBIAN"
else
    echo "This script currently supports Arch and Debian-based distributions only."
    exit 1
fi

# Install Dependencies based on the OS
if [ "$OS" == "ARCH" ]; then
    sudo pacman -S --noconfirm base-devel cmake libevdev libconfig systemd-libs glib2
elif [ "$OS" == "DEBIAN" ]; then
    sudo apt update && sudo apt install -y build-essential cmake pkg-config libevdev-dev libudev-dev libconfig++-dev libglib2.0-dev
fi

# Clone and Install the Tool
git clone https://github.com/PixlOne/logiops.git ~/Documents/Logiops
cd ~/Documents/Logiops
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
sudo make install
sudo systemctl enable --now logid

echo "Installation complete!"
