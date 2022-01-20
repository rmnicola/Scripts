#! /usr/bin/bash

if [[ ! $SUDO_USER ]]; then echo "Please run this script as root."; exit; fi

function deescalate() {
	su $SUDO_USER -c '$@'
}

function deescalate_user() {
	sudo -u $SUDO_USER $@
}

# This doesn't really belong here, change later.
function check_operation() {
  if [ $? -eq 0 ]; then echo ">> $@ successfull."
  else echo ">> Failed: $@."
  fi
}

