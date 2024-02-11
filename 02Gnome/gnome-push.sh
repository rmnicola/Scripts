#!/bin/bash

check_figlet_installed() {
    if [[ ! -x $(which figlet) ]]; then
        printf "This script uses Figlet. Install it before continuing..."
        exit 1
    fi
}

# Function to check if charm tools are installed
check_charm_tools_installed() {
    if [[ ! -x $(which gum) ]]; then
        printf "This script uses Gum. Install it before continuing...
        Try running install-charm-tools."
        exit 1
    fi
}

install_gdrive() {
    gum log -sl error "Gdrive tool is not installed. Please install it and run the script again."
    gum log -sl error $(gum style --underline "https://github.com/glotlabs/gdrive/releases")
    gum log -sl error $(gum style --underline "https://console.cloud.google.com/apis/credentials?project=rclone-rmnicola")
    xdg-open "https://github.com/glotlabs/gdrive/releases" &> /dev/null & 
    xdg-open "https://console.cloud.google.com/apis/credentials?project=rclone-rmnicola" &> /dev/null &
    exit 1
}

check_gdrive_installed() {
    if [[ ! -x $(which gdrive) ]]; then
        install_gdrive
    fi
}


main_menu() {
    gum style \
      --border double \
      --align center --width 50 --margin "1 2" --padding "2 4" \
      "
$(figlet GNOME)
$(figlet PUSH)

This tool will help you create a backup for your gnome configuration.

Choose the destination of your backup file:"

choice=$(gum choose "Write to file" "Write to Ubuntu dconf (drive)" "Write to Arch dconf (drive)")
    
    case $choice in
        "Write to file")
            file_name=$(gum input --placeholder "gdrive_backup.txt")
            dconf dump / > "$file_name"
            ;;
        "Write to Ubuntu dconf (drive)")
            TMP_FILE="ubuntu_dconf.txt"
            dconf dump / > "$TMP_FILE"
            gdrive files update 10Jroh7WtnzQ46-PFapr5_FrJyNG_Wf-1 "$TMP_FILE"
            rm "$TMP_FILE"
            ;;
        "Write to Arch dconf (drive)")
            TMP_FILE="arch_dconf.txt"
            dconf dump / > "$TMP_FILE"
            gdrive files update 1iqceApR2HLhYJpw26A98ETyLZvIaC5Q2 "$TMP_FILE"
            rm "$TMP_FILE"
            ;;
        *)
            echo "Invalid option selected."
            exit 1
            ;;
    esac
}


check_figlet_installed
check_charm_tools_installed
check_gdrive_installed

# Display the main menu
main_menu
