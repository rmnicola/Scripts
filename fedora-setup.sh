#!/usr/bin/bash

# Configures dnf
echo "Configuring dnf..."

declare DNF_CONF_PATH="/etc/dnf/dnf.conf"
declare -a CONF_ARRAY=("fastest_mirror=True" "max_parallel_downloads=10")
declare -i DNF_CHANGES=0

# Loop every configuration and checks if it already exists
for CONF in ${CONF_ARRAY[@]}; do
	if ! grep -Fxq $CONF $DNF_CONF_PATH ; then 
		# If it does not exist, add it
		sudo sed -i "/^[main]/a $CONF" $DNF_CONF_PATH 
		echo "Added option $CONF!"
		let "DNF_CHANGES+=1"
	else
		echo "Option $CONF has already been added"
	fi
done

# Updates dnf config if there were changes
if [ $DNF_CHANGES -gt 0 ] ; then
	echo "Cleaning up..."
	sudo dnf clean all
else
	echo "No changes were made, moving on..."
fi

# Updates system packages
read -p "Update system (this may take a few minutes)? [y/N] " UPDATE_OPTION
if [ "${UPDATE_OPTION,,}" = "y" ] ; then
	sudo dnf -y update
fi

# Download and configure zsh
read -p "Do you wish to use ZSH instead of BASH? [y/N] " ZSH_OPTION
if [ "${ZSH_OPTION,,}" = "y" ] ; then
	sudo dnf -y install zsh
fi
