#! /bin/bash

if [[ -x $(which gum) ]]; then
  echo "Gum is already installed"
else
  echo "Installing Gum..."
  go install github.com/charmbracelet/gum@latest
fi

if [[ -x $(which vhs) ]]; then
  echo "VHS is already installed"
else
  echo "Installing VHS..."
  go install github.com/charmbracelet/vhs@latest
fi
