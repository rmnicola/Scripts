#!/bin/bash

# Configuration
PRESENT_ROOT="$HOME/Documents/Presentations"
ICON="📺"

# 1. Select Presentation
SELECTION=$(find "$PRESENT_ROOT" -mindepth 1 -maxdepth 1 -type d -printf \
  '%f\n' | sort | sed "s/^/$ICON /" |\
  walker --dmenu --placeholder "📺 Present")

[ -z "$SELECTION" ] && exit 0

SELECTED_DIR="${SELECTION#$ICON }"
FULL_PATH="$PRESENT_ROOT/$SELECTED_DIR"
FILE_PATH="$FULL_PATH/present.md"

if [ ! -f "$FILE_PATH" ]; then
    notify-send "❌ Error" "File 'present.md' not found in $SELECTED_DIR"
    exit 1
fi

# 2. Launch Ghostty Fullscreen
# We use hyprctl to spawn it with the specific flags you requested.
# --font-size=20 makes it readable for audiences.
hyprctl dispatch exec "[fullscreen] kitty -o font_size=20 \
--working-directory='$FULL_PATH' presenterm present.md"
