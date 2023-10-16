#!/bin/bash
if command cargo &> /dev/null; then
  echo "Rust is already installed"
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
