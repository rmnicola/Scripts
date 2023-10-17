#!/bin/bash
#

if ! command -v cargo &> /dev/null; then
  echo "Rust no installed. Installing..."
  install-rust
else
  echo "Rust already installed..."
fi

# Check if 'fnm' command is available
if ! command -v fnm &> /dev/null; then
  echo "fnm is not installed. Installing now..."
  cargo install fnm
else
  echo "fnm is already installed."
fi

# Use 'fnm' to install latest version of Node.js
fnm install --latest
echo "Node.js has been installed via fnm."
node --version
