#!/bin/bash

# Get the vendor ID and product ID for the "Intel Corp. AX201 Bluetooth" device
DEVICE_ID=$(lsusb | grep "Intel Corp. AX201 Bluetooth" | awk '{print $6}')

if [ -z "$DEVICE_ID" ]; then
    echo "Device 'Intel Corp. AX201 Bluetooth' not found."
    exit 1
fi

# Create a custom udev rule
UDEV_RULE="SUBSYSTEM==\"usb\", ATTR{idVendor}==\"${DEVICE_ID%%:*}\", ATTR{idProduct}==\"${DEVICE_ID##*:}\", ATTR{power/control}=\"on\""

# Write the rule to the udev rules directory
echo "$UDEV_RULE" | sudo tee /etc/udev/rules.d/81-bluetooth-autosuspend.rules

# Reload udev rules
sudo udevadm control --reload-rules && sudo udevadm trigger

echo "Udev rule created and applied successfully."
