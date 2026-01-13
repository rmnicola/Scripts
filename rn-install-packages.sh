#!/bin/bash

# Configuration
INPUT_FILE="packages.txt"
FINAL_LIST=()

# Check for dependencies
if ! command -v gum &> /dev/null; then
    sudo pacman -S --noconfirm gum
    exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: '$INPUT_FILE' not found."
    exit 1
fi

# Variables to hold state during parsing
current_section="General" # Default section if no header is found first
current_pkgs=()

# Function to prompt the user for the current buffer of packages
prompt_section() {
    # Only prompt if there are packages in the buffer
    if [ ${#current_pkgs[@]} -gt 0 ]; then
        echo "" 
        # Use gum to let user select (no limit on selection)
        # We pass the array elements as newlines to gum
        selected=$(printf "%s\n" "${current_pkgs[@]}" | gum choose --no-limit --height 10 --header "Select packages for section: $current_section")
        
        # If user selected something, add to final list
        if [ -n "$selected" ]; then
            # We must handle newlines from gum output and convert to array
            while IFS= read -r item; do
                FINAL_LIST+=("$item")
            done <<< "$selected"
        fi
    fi
}

# --- Main Parsing Loop ---
while IFS= read -r line || [ -n "$line" ]; do
    # 1. Skip empty lines
    if [[ -z "${line// }" ]]; then
        continue
    fi

    # 2. Check if line is a Header (starts with #)
    if [[ "$line" == \#* ]]; then
        # If we hit a new header, process the PREVIOUS section first
        prompt_section
        
        # Reset for the new section
        # Remove the '#' and leading/trailing whitespace
        current_section=$(echo "${line}" | sed 's/^#//' | xargs)
        current_pkgs=()
    else
        # 3. It's a package, add to buffer
        # Strip whitespace just in case
        pkg=$(echo "$line" | xargs)
        current_pkgs+=("$pkg")
    fi
done < "$INPUT_FILE"

# Process the very last section after the loop ends
prompt_section

# --- Installation Phase ---

if [ ${#FINAL_LIST[@]} -eq 0 ]; then
    gum style --foreground 196 "No packages selected. Exiting."
    exit 0
fi

# Convert array to space-separated string for display
PACKAGES_STR="${FINAL_LIST[*]}"

echo ""
gum style --border normal --padding "1 2" --border-foreground 212 "Ready to install the following packages:"
echo "$PACKAGES_STR"
echo ""

# Confirm before running yay
if gum confirm "Proceed with installation?"; then
    # Use yay to install (handles both repo and AUR)
    yay -S --needed $PACKAGES_STR
else
    gum style --foreground 196 "Installation cancelled."
fi
