#!/bin/bash

# If the first argument is --forced, use the Nuclear option.
if [ "$1" == "--forced" ]; then
    shift  # Remove "--forced" so $1 becomes the URL
    MODE="nuclear"
else
    MODE="standard"
fi

URL="$1"

if [ "$MODE" == "nuclear" ]; then
    # --- NUCLEAR OPTION (Chromium -> rdrview -> w3m) ---
    # Used for NYT/Bloomberg or sites with JS Paywalls.
    UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    
    # Run headless chromium to dump the DOM, clean it, and pipe to w3m
    chromium --headless=new --dump-dom --user-agent="$UA" "$URL" 2>/dev/null | rdrview -B w3m
else
    # --- STANDARD OPTION (rdrview -> w3m) ---
    # Lightweight, fast, no browser engine. Best for Folha, blogs, etc.
    # We pass the width/type flags to w3m via the -B argument.
    rdrview -B w3m "$URL"
fi
