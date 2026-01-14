#!/bin/bash

# ==========================================
# Omarchy Package Installer
# Matches visual style of Omarchy Cleaner
# ==========================================

# Configuration
INPUT_FILE="packages.txt"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Locate packages.txt (Check current dir, then script dir, then parent dir)
if [ -f "$INPUT_FILE" ]; then
    TARGET_FILE="$INPUT_FILE"
elif [ -f "$SCRIPT_DIR/$INPUT_FILE" ]; then
    TARGET_FILE="$SCRIPT_DIR/$INPUT_FILE"
elif [ -f "$SCRIPT_DIR/../$INPUT_FILE" ]; then
    TARGET_FILE="$SCRIPT_DIR/../$INPUT_FILE"
else
    # Error will be handled in Main
    TARGET_FILE=""
fi

# State Variables
FINAL_LIST=()
MODE="interactive"
TARGET_SECTION=""

# ==========================================
# UI Functions
# ==========================================

show_header() {
    clear
    # Header Style matching Cleaner
    gum style \
        --foreground 212 \
        "   ____             __        __  " \
        "  /  _/___  _______/ /_____ _/ / /" \
        "  / // __ \/ ___/ __/ __  / / / " \
        "_/ // / / (__  ) /_/ /_/ / / /  " \
        "/___/_/ /_/____/\__/\__,_/_/_/   " \
        "                                 "

    echo ""
    gum style --foreground 237 "═════════════════════════════════════════════════"
    echo ""
}

show_summary() {
    local attempted=$1
    local failed=$2
    local successful=$((attempted - failed))

    echo ""
    if [[ $failed -eq 0 ]]; then
        # Green Hero
        gum style \
            --border double --border-foreground 82 --background 22 --foreground 15 \
            --bold --padding "1 2" --margin "1" --width 60 --align center \
            "✅ SUCCESS" "" "All $attempted package(s) processed successfully!"
        return 0
    elif [[ $successful -gt 0 ]]; then
        # Orange Hero
        gum style \
            --border double --border-foreground 214 --background 94 --foreground 15 \
            --bold --padding "1 2" --margin "1" --width 60 --align center \
            "⚠️  PARTIAL SUCCESS" "" "$successful installed, $failed failed."
        return 1
    else
        # Red Hero
        gum style \
            --border double --border-foreground 196 --background 52 --foreground 15 \
            --bold --padding "1 2" --margin "1" --width 60 --align center \
            "❌ FAILED" "" "Could not install packages."
        return 2
    fi
}

# ==========================================
# Logic Functions
# ==========================================

# Parse packages.txt based on the current Mode
# Populates: FINAL_LIST array
parse_packages() {
    if [[ ! -f "$TARGET_FILE" ]]; then
        gum log --level error "Could not find '$INPUT_FILE'"
        exit 1
    fi

    local capture=false
    # If mode is all, we default to capturing everything
    if [[ "$MODE" == "all" ]]; then capture=true; fi

    while IFS= read -r line || [ -n "$line" ]; do
        # Cleanup line
        line=$(echo "$line" | xargs)

        # Skip empty
        if [[ -z "$line" ]]; then continue; fi

        # Header detection
        if [[ "$line" == \#* ]]; then
            local header_name=$(echo "${line}" | sed 's/^#//' | xargs)
            
            # If in section mode, toggle capture based on name match
            if [[ "$MODE" == "section" ]]; then
                if [[ "${header_name,,}" == "${TARGET_SECTION,,}" ]]; then
                    capture=true
                else
                    capture=false
                fi
            fi
            continue
        fi

        # Skip metadata lines
        if [[ "$line" == \[* ]]; then continue; fi

        # Add package
        if [[ "$capture" == "true" ]]; then
            FINAL_LIST+=("$line")
        fi

    done < "$TARGET_FILE"
}

# Install the packages in FINAL_LIST with fancy progress bars
install_process() {
    local packages=("${FINAL_LIST[@]}")
    local failed_packages=()
    local success_count=0
    
    local total=${#packages[@]}
    local current=0

    echo ""
    gum style --foreground 212 --bold "📦 Installing $total package(s)..."
    echo ""

    # Sudo check
    if ! sudo -n true 2>/dev/null; then
        gum style --foreground 214 "🔐 Sudo privileges required for installation"
        if ! sudo true; then
             gum log --level error "Failed to obtain sudo."
             return 1
        fi
        echo ""
    fi

    for pkg in "${packages[@]}"; do
        ((current++))

        # 1. Progress Text
        gum style --foreground 212 "[$current/$total] Processing: $pkg"

        # 2. Spinner & Action
        # Note: We use yay. If you strictly use pacman, change 'yay' to 'sudo pacman'
        if gum spin --spinner dot --title "Installing $pkg..." -- bash -c "yay -S --needed --noconfirm '$pkg' >/dev/null 2>&1"; then
            gum log --level info "✓ Installed: $pkg"
            ((success_count++))
        else
            gum log --level warn "✗ Failed: $pkg"
            failed_packages+=("$pkg")
        fi

        # 3. Progress Bar (Visual Match to Cleaner)
        local percentage=$(( (current * 100) / total ))
        local filled=$(( percentage / 5 ))
        local empty=$(( (100 - percentage) / 5 ))

        printf "Progress: "
        printf '\033[92m█%.0s\033[0m' $(seq 1 $filled)
        printf '\033[90m░%.0s\033[0m' $(seq 1 $empty)
        printf " %d%% (%d/%d)\n" "$percentage" "$current" "$total"
        echo ""
    done

    show_summary "$total" "${#failed_packages[@]}"
}

# Interactive Selector (for when no flags are passed)
run_interactive_selector() {
    show_header

    if [[ ! -f "$TARGET_FILE" ]]; then
         gum style --foreground 196 "Error: packages.txt not found."
         exit 1
    fi

    # Read file to build display list (Section: Package)
    local display_items=()
    local current_sect="General"

    while IFS= read -r line || [ -n "$line" ]; do
        line=$(echo "$line" | xargs)
        if [[ -z "$line" ]]; then continue; fi
        
        if [[ "$line" == \#* ]]; then
            current_sect=$(echo "${line}" | sed 's/^#//' | xargs)
            continue
        fi

        if [[ "$line" == \[* ]]; then continue; fi

        # Add to display list with section prefix for clarity
        display_items+=("[$current_sect] $line")
    done < "$TARGET_FILE"

    # Gum Filter
    echo ""
    gum style --foreground 212 --italic "Select packages to install (Tab to select, Enter to confirm)"
    echo ""

    local selected_items=$(printf '%s\n' "${display_items[@]}" | \
        gum filter --no-limit --indicator " ▸" --selected-prefix " 📦 " --unselected-prefix "    " \
        --placeholder "Search packages..." --height 15)

    if [[ -z "$selected_items" ]]; then
        gum style --foreground 196 "No packages selected. Exiting."
        exit 0
    fi

    # Parse selection back to clean package names
    while IFS= read -r item; do
        # Remove [Section] prefix
        clean_pkg=$(echo "$item" | sed 's/^\[.*\] //')
        FINAL_LIST+=("$clean_pkg")
    done <<< "$selected_items"
}

# ==========================================
# Main Execution
# ==========================================

# Dependency Check
if ! command -v gum &> /dev/null; then
    echo "Error: gum is not installed."
    exit 1
fi

# Argument Parsing
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --section) TARGET_SECTION="$2"; MODE="section"; shift ;;
        --all) MODE="all" ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Logic Flow
if [[ "$MODE" == "interactive" ]]; then
    run_interactive_selector
    
    # Confirmation for Interactive Mode
    echo ""
    gum style --bold "Ready to install ${#FINAL_LIST[@]} packages."
    if ! gum confirm "Proceed?"; then
        gum log --level info "Operation cancelled"
        exit 0
    fi
else
    # Wizard Mode (Silent build of list)
    parse_packages
fi

# Final Safety Check
if [ ${#FINAL_LIST[@]} -eq 0 ]; then
    gum style --foreground 196 "No packages found to install."
    exit 0
fi

# Run Installation
install_process
