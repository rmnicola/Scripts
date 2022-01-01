#!/usr/bin/bash

# Configures dnf
echo "Configuring dnf..."
DNF_CONF_PATH="/etc/dnf/dnf.conf"
declare -a CONF_ARRAY=("fastest_mirror=True" "max_parallel_downloads=10")
# Loop every configuration and checks if it already exists
for CONF in ${CONF_ARRAY[@]}; do
	if ! grep -Fxq "$CONF" $DNF_CONF_PATH; then 
		# If it does not exist, add it
		sudo sed -i "/^[main]/a $CONF" $DNF_CONF_PATH 
		echo "Added option $CONF!"
	else
		echo "Option $CONF has already been added"
	fi
done
# Updates dnf config
echo "Cleaning up..."
sudo dnf clean all

# Updates system packages
echo "Updating entire system. This may take a few minutes..."
sudo dnf -y update
