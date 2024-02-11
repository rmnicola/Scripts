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

# Function to download and restore GNOME configuration from Google Drive
restore_from_google_drive() {
    local google_drive_link="$1"
    local output_file="/tmp/gnome_config_backup.txt"
    echo "Downloading GNOME configuration from Google Drive..."
    curl -L "$google_drive_link" --output "$output_file"
    dconf reset -f /
    dconf load / < "$output_file"
    rm "$output_file"
    echo "GNOME configuration restore from Google Drive complete."
}

# Main menu using charm CLI tools
main_menu() {
    gum style \
      --border double \
      --align center --width 50 --margin "1 2" --padding "2 4" \
      "
$(figlet GNOME)
$(figlet PULL)

This tool will help you restore your backed up gnome configuration.

Choose the source of your backup file:"

    choice=$(gum choose "Restore from file" "Restore from Ubuntu dconf (drive)" "Restore from Arch dconf (drive)" "Restore from another source")
    
    case $choice in
        "Restore from file")
            file_name=$(gum input --placeholder "gdrive_backup.txt")
            if [[ -f "$file_name" ]]; then
                dconf reset -f /
                dconf load / < "$file_name"
                echo "GNOME configuration restore from dump file complete."
            else
                echo "Error: File '$file_name' not found."
                exit 1
            fi
            ;;
        "Restore from Ubuntu dconf (drive)")
            restore_from_google_drive "https://drive.google.com/uc?export=download&id=10Jroh7WtnzQ46-PFapr5_FrJyNG_Wf-1"
            ;;
        "Restore from Arch dconf (drive)")
            restore_from_google_drive "https://drive.google.com/uc?export=download&id=1iqceApR2HLhYJpw26A98ETyLZvIaC5Q2"
            ;;
        "Restore from another source")
            google_drive_link=$(gum input --placeholder "Enter the Google Drive link")
            restore_from_google_drive "$google_drive_link"
            ;;
        *)
            echo "Invalid option selected."
            exit 1
            ;;
    esac
}


# Check if figlet is installed
check_figlet_installed

# Check if charm tools are installed
check_charm_tools_installed

# Display the main menu
main_menu
