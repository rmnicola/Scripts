#!/usr/bin/bash

# Grab script dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Require sudo
source $SCRIPT_DIR/require-sudo.sh

echo ">> Configuring dnf."

# Set the config file path
declare DNF_CONF_PATH="/etc/dnf/dnf.conf"

# Set array of configurations
declare -a CONF_ARRAY=(	"fastest_mirror=True"		\
		       	"max_parallel_downloads=10" )

# Keeps tab of how many changes were actually made
declare -i DNF_CHANGES=0


# Loop every configuration and checks if it already exists
for CONF in ${CONF_ARRAY[@]}; do
	echo ">>>> Checking option $CONF."
	if ! grep -Fxq $CONF $DNF_CONF_PATH ; then 
		# If it does not exist, add it
		sed -i "/^[main]/a $CONF" $DNF_CONF_PATH 
		echo ">>>>>> Added option $CONF!"

		# Increment changes made
		let "DNF_CHANGES++"
	else
		echo ">>>>>> Option $CONF has already been added"
	fi
done

# If any changes were actually made, clean dnf
if [ $DNF_CHANGES -gt 0 ] ; then
	echo ">>>> Changes detected. Cleaning up."
	dnf clean all
else
	echo ">>>> No changes were made, moving on."
fi

