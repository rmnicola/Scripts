#!/bin/bash

if [[ ! -x $(which figlet) ]]; then
    echo "This script uses Figlet. Install it before continuing..."
    exit 1
fi

if [[ ! -x $(which gum) ]]; then
    echo "This script uses Gum. Install it before continuing..."
    echo "Try running install-charm-tools."
    exit 1
fi

set -e

gum style \
	--border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
  --foreground "#9e53bc" \
  "$(figlet ROS)" \
  "$(figlet Install)"

apt list --installed 2> /dev/null | grep -q software-properties-common
if [[ "$?" -eq 0 ]]; then
    echo "Software-properties-common already installed. Skipping this step..."
else
    echo "Installing software-properties-common..."
    sleep 2
    sudo apt install software-properties-common -y
fi

grep universe -q /etc/apt/sources.list /etc/apt/sources.list.d/*
if [[ "$?" -eq 0 ]]; then
    echo "Universe repository already added. Skipping this step..."
else
    echo "Adding universe repository..."
    sudo add-apt-repository universe
    sudo apt update
fi

grep ros2 -q /etc/apt/sources.list /etc/apt/sources.list.d/*
if [[ "$?" -eq 0 ]]; then
    echo "ROS2 repository already added. Skipping this step..."
else
    echo "Adding ros2 repository..."
    sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
    sudo apt update
fi

echo "Choose what you want to do (space to select):"
GUM_OPTIONS=$(gum choose --no-limit "Install ROS2" "Install colcon build tools" "Install turtlebot3 packages" "Configure setup script")

if [[ "$GUM_OPTIONS" =~ "ROS2" ]]; then
    sudo apt install -y ros-humble-desktop
fi

if [[ "$GUM_OPTIONS" =~ "colcon" ]]; then
    sudo apt install -y python3-colcon-common-extensions
fi

if [[ "$GUM_OPTIONS" =~ "turtlebot3" ]]; then
    sudo apt install -y ros-humble-turtlebot3*
fi

if [[ "$GUM_OPTIONS" =~ "setup" ]]; then
    echo "Choose the destination file for the source command:"
    RC_PATH=$(gum choose "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.zshenv" "$HOME/.config/zsh/.zshrc" "$HOME/.config/zsh/.zshenv")
    echo "$RC_PATH" | grep -q "bash"
    if [[ "$?" -eq 0 ]]; then
        echo "source /opt/ros/humble/setup.bash" >> "$RC_PATH"
    else
        echo "source /opt/ros/humble/setup.zsh" >> "$RC_PATH"
    fi
fi

echo "All done. Enjoy =D"
