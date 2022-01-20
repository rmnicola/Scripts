#! /usr/bin/bash

# Grab script dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Require sudo
source $SCRIPT_DIR/require-sudo.sh

echo ">> Adding first-party repos."
dnf install \
	"https://download1.rpmfusion.org/free/fedora/"\
	"rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
dnf install \
	"https://download1.rpmfusion.org/nonfree/fedora/"\
	"rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
echo ">> Installing apps from applist."
dnf install $(cat applist.txt);
check_operation Add first-party repos 

echo ">> Adding flathub repo to flatpak."
flatpak remote-add --if-not-exists flathub \
  https://flathub.org/repo/flathub.flatpakrepo
check_operation Add flathub repo

echo ">> Installing apps from flatpak.txt"
flatpak install $(cat flatpak.txt)
check_operation Flatpak apps installation
