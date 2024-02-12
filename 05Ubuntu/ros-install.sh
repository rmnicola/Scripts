#!/bin/bash

set -e

sudo apt install software-properties-common -y
sudo add-apt-repository universe
sudo apt update && sudo apt install -y curl gnupg2 lsb-release

# Update system
sudo apt update && sudo apt upgrade -y

# Check if the ROS 2 repository has already been added
if grep -qF "http://packages.ros.org/ros2/ubuntu" /etc/apt/sources.list.d/ros2.list 2>/dev/null; then
    echo "ROS 2 repository already added."
else
    echo "Adding ROS 2 repository..."
    # Add the ROS 2 apt repository
    sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
    sudo apt update
fi

# Install ROS 2
sudo apt install -y ros-humble-desktop

# Install colcon, the ROS 2 build tool
sudo apt install -y python3-colcon-common-extensions

# Notify user
echo "ROS 2 Humble has been installed! If you haven't already, add 'source /opt/ros/humble/setup.(zsh/bash)' to your shell config file"
