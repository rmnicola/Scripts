#!/usr/bin/bash

# Grab script dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Require sudo
source $SCRIPT_DIR/require-sudo.sh

echo ">> Disabling Network Manager Wait Online Service."
systemctl disable NetworkManager-wait-online.service
check_operation Disable Wait Online

echo ">> Configuring deep sleep option"
sed -i 's/\(GRUB_CMDLINE_LINUX="\)\([a-z ]*\)"/\1\2 mem_sleep_default=deep"/' \
  /etc/default/grub
check_operation Configure deep-sleep grub

echo ">> Configuring grub timeout."
sed -i 's/\(GRUB_TIMEOUT=\)[0-9]*/\10/' \
  /etc/default/grub
check_operation Configure grub timeout

echo ">> Setting menu auto-hide to 1"
grub2-editenv - set menu_auto_hide=1
check_operation Set menu auto-hide

echo ">> Updating grub config."
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
check_operation Generate grub config
