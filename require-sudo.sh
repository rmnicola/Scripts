#! /usr/bin/bash

if [[ ! $SUDO_USER ]]; then echo "Please run this script as root."; exit; fi

function deescalate() {
	su $SUDO_USER -c '$@'
}

function deescalate_user() {
	sudo -u $SUDO_USER $@
}

