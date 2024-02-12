#!/bin/bash

if [[ ! -x $(which figlet) ]]; then
    echo "This script uses Rust. Install it before continuing..."
    echo "Try running install-rust."
    exit 1
fi

if [[ ! -x $(which fnm) ]]; then
    echo "Fnm not installed. Installing..."
    cargo install fnm
else
  echo "Fnm is already installed."
fi

echo "Installing the latest version of node..."
fnm install --latest
echo "Node.js has been installed via fnm."
node --version
