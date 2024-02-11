#!/bin/bash

# URL of the font on GitHub
COMIC_URL="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/ComicShannsMono/ComicShannsMonoNerdFont-Regular.otf"
DYSLEXIC_URL="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/OpenDyslexic/Mono-Regular/OpenDyslexicMNerdFontMono-Regular.otf"

# Download directory
TMP_DIR=$(mktemp -d)

# Font name
COMIC_NAME="ComicShannsMonoNerdFont-Regular.otf"
DYSLEXIC_NAME="OpenDyslexicMNerdFontMono-Regular"

# Download the fonts
wget -O "${TMP_DIR}/${COMIC_NAME}" "$COMIC_URL"
wget -O "${TMP_DIR}/${DYSLEXIC_NAME}" "$DYSLEXIC_URL"

# Check if ~/.fonts directory exists, if not, create it
if [ ! -d ~/.fonts ]; then
    mkdir ~/.fonts
fi

# Move the font to the ~/.fonts directory
mv "${TMP_DIR}"/* ~/.fonts/

# Refresh the font cache
fc-cache -f -v

# Cleanup
rm -r "$TMP_DIR"
echo "Fonts installed successfully!"
