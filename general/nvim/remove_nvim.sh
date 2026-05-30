#!/usr/bin/env bash

set -e

if [ -z "$SUDO_USER" ]; then
    echo "Run with sudo"
    exit 1
fi

USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)


echo "Removing Neovim user data..."

rm -rf "$USER_HOME/.config/nvim"
rm -rf "$USER_HOME/.local/share/nvim"
rm -rf "$USER_HOME/.local/state/nvim"
rm -rf "$USER_HOME/.cache/nvim"

echo "Removing Neovim source installation..."

rm -f /usr/local/bin/nvim
rm -rf /usr/local/share/nvim
rm -rf /usr/local/lib/nvim
rm -f /usr/local/share/man/man1/nvim.1

echo "Neovim removed."
