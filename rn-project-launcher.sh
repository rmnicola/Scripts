#!/bin/bash

# Configuration
PROJECTS_ROOT="$HOME/Documents/Projects"
PROFILES_ROOT="$HOME/.local/share/project-browser-profiles"
TERM_WORKSPACE=3
BROWSER_WORKSPACE=4
ICON="📂"

# --- 1. Select the project ---
SELECTION=$(find "$PROJECTS_ROOT" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | sed "s/^/$ICON /" | walker --dmenu --placeholder "🚀 Select Project")

[ -z "$SELECTION" ] && exit 0

SELECTED_DIR="${SELECTION#$ICON }"
FULL_PATH="$PROJECTS_ROOT/$SELECTED_DIR"
SESSION_NAME=$(echo "$SELECTED_DIR" | tr '[:upper:]' '[:lower:]' | sed 's/[_ ]/-/g')
PROJECT_PROFILE="$PROFILES_ROOT/$SESSION_NAME"

# --- 2. Handle Browser (Workspace 4) ---

# Check if this is a brand new profile
if [ ! -d "$PROJECT_PROFILE" ]; then
    # Create the directory structure manually
    mkdir -p "$PROJECT_PROFILE/Default"

    # Inject the "Continue where you left off" preference
    # '1' = Restore last session
    echo '{ "session": { "restore_on_startup": 1 } }' > "$PROJECT_PROFILE/Default/Preferences"
fi

# Clear Workspace 4
hyprctl clients -j | jq -r ".[] | select(.workspace.id == $BROWSER_WORKSPACE) | .address" | xargs -r -I{} hyprctl dispatch closewindow address:{}

# Launch Chromium with persistent profile
nohup chromium \
    --class="com.projbrowser" \
    --user-data-dir="$PROJECT_PROFILE" \
    >/dev/null 2>&1 &

# --- 3. Handle Terminal (Workspace 3) ---

# Clear Workspace 3
hyprctl clients -j | jq -r ".[] | select(.workspace.id == $TERM_WORKSPACE) | .address" | xargs -r -I{} hyprctl dispatch closewindow address:{}

# Switch focus
hyprctl dispatch workspace $TERM_WORKSPACE

# Launch Ghostty
ghostty \
  --class="com.projterm" \
  --working-directory="$FULL_PATH" \
  -e zellij attach -c "$SESSION_NAME" &

exit 0
