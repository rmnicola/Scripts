#!/bin/bash

# Ensure the script exits immediately if a command exits with a non-zero status
set -e

# Verificar e criar /etc/apt/sources.list se não existir
if [[ ! -f /etc/apt/sources.list ]]; then
    sudo touch /etc/apt/sources.list
    echo "/etc/apt/sources.list created."
fi

# Verificar e criar o diretório /etc/apt/sources.list.d se não existir
if [[ ! -d /etc/apt/sources.list.d ]]; then
    sudo mkdir -p /etc/apt/sources.list.d
    echo "/etc/apt/sources.list.d directory created."
fi

# Verifica a instalação de ferramentas necessárias
if ! command -v figlet &> /dev/null; then
    echo "This script uses Figlet. Install it before continuing..."
    exit 1
fi

if ! command -v gum &> /dev/null; then
    echo "This script uses Gum. Install it before continuing..."
    echo "Try running install-charm-tools."
    exit 1
fi

# Usar gum para estilizar a saída
GUM_OUTPUT=$(gum style --border double --align center --width 50 --margin "1 2" --padding "2 4" --foreground "#9e53bc" "$(figlet ROS)$(figlet Install)")
echo "$GUM_OUTPUT"

# Verificar e instalar software-properties-common se necessário
if ! dpkg -l | grep -qw software-properties-common; then
    echo "Installing software-properties-common..."
    sleep 2
    sudo apt-get install -y software-properties-common
else
    echo "Software-properties-common already installed. Skipping this step..."
fi

# Verificar e adicionar o repositório universe se necessário
if ! grep -q universe /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding universe repository..."
    sudo add-apt-repository universe
    sudo apt-get update
else
    echo "Universe repository already added. Skipping this step..."
fi

# Verificar e adicionar o repositório ROS2 se necessário
if ! grep -q ros2 /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding ros2 repository..."
    sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
    sudo apt-get update
else
    echo "ROS2 repository already added. Skipping this step..."
fi

# Seleção de opções com Gum
echo "Choose what you want to do (space to select):"
GUM_OPTIONS=$(gum choose --no-limit "Install ROS2" "Install colcon build tools" "Install turtlebot3 packages" "Configure setup script")

# Instalar pacotes conforme as opções escolhidas
if [[ "$GUM_OPTIONS" =~ "ROS2" ]]; then
    sudo apt-get install -y ros-humble-desktop
fi

if [[ "$GUM_OPTIONS" =~ "colcon" ]]; then
    sudo apt-get install -y python3-colcon-common-extensions
fi

if [[ "$GUM_OPTIONS" =~ "turtlebot3" ]]; then
    sudo apt-get install -y ros-humble-turtlebot3*
fi

if [[ "$GUM_OPTIONS" =~ "setup" ]]; then
    echo "Choose the destination file for the source command:"
    RC_PATH=$(gum choose "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.zshenv" "$HOME/.config/zsh/.zshrc" "$HOME/.config/zsh/.zshenv")
    if echo "$RC_PATH" | grep -q "bash"; then
        echo "source /opt/ros/humble/setup.bash" >> "$RC_PATH"
    else
        echo "source /opt/ros/humble/setup.zsh" >> "$RC_PATH"
    fi
fi

echo "All done. Enjoy =D"
