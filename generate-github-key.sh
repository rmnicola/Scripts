#!/bin/bash

# Generate SSH key
ssh-keygen -t rsa -b 4096

# Copy public key to clipboard
if [ -x "$(command -v xclip)" ]; then
  cat ~/.ssh/id_rsa.pub | xclip -sel clip
  echo "Public key copied to clipboard!"
elif [ -x "$(command -v pbcopy)" ]; then
  cat ~/.ssh/id_rsa.pub | pbcopy
  echo "Public key copied to clipboard!"
else
  echo "Couldn't copy public key to clipboard - xclip and pbcopy are not installed."
fi
