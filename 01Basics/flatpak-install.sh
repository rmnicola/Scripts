#!/bin/bash

if [[ -x $(which flatpak) ]]; then
    echo "Flatpak already installed."
else
    echo "Installing flatpak..."
    if [ -f "/etc/os-release" ]; then
        source /etc/os-release
        case $ID in
            "ubuntu")
                sudo apt install -y flatpak
                ;;
            "arch")
                sudo pacman -Syu flatpak --noconfirm
                ;;
            *)
                echo "Get out of here with that shit distro!!"
                exit 1
        esac
    else
        echo "What on earth are you even using? Get out of here!!"
        exit 1
    fi
fi

echo "Adding flathub remote..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

if [[ $? ]]; then
    echo "Done!"
else
    echo "There was an error adding the remote..."
fi
