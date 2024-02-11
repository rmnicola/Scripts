#! /bin/bash

if [[ ! -x $(which go) ]]; then
  echo "Go is not installed. You need Go to proceed."
  echo "Try running go-install."
  exit 1
fi

if [[ -x $(which gum) ]]; then
  echo "Gum is already installed"
else
  echo "Installing Gum..."
  sleep 2
  go install github.com/charmbracelet/gum@latest
fi

if [[ -x $(which vhs) ]]; then
  echo "VHS is already installed"
else
  echo "Installing VHS..."
  sleep 2
  go install github.com/charmbracelet/vhs@latest
fi
