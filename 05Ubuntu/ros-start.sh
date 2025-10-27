## Detectar a versão do Ubuntu e definir a distro do ROS
UBUNTU_VERSION=$(lsb_release -rs)
case $UBUNTU_VERSION in
    "24.04")
        ROS_DISTRO="jazzy"
        ;;
    "22.04")
        ROS_DISTRO="humble"
        ;;
    "20.04")
        ROS_DISTRO="foxy"
        ;;
    *)
        ROS_DISTRO="humble"  ## fallback padrão
        ;;
esac

## Detectar o shell atual automaticamente
case "$SHELL" in
    */zsh)
        source "/opt/ros/${ROS_DISTRO}/setup.zsh"
        ;;
    */bash)
        source "/opt/ros/${ROS_DISTRO}/setup.bash"
        ;;
    *)
        source "/opt/ros/${ROS_DISTRO}/setup.bash"  # fallback padrão
        ;;
esac

# argcomplete for ros2 & colcon
eval "$(register-python-argcomplete3 ros2)"
eval "$(register-python-argcomplete3 colcon)"