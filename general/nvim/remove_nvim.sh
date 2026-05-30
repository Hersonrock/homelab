#!/usr/bin/env bash

apt -y remove neovim 
FUSER_HOME=$( getent passwd "$SUDO_USER" | cut -d: -f6)

rm -rf "$USER_HOME/.config/nvim"
rm -rf "$USER_HOME/.local/share/nvim"
rm -rf "$USER_HOME/.local/state/nvim"
rm -rf "$USER_HOME/.cache/nvim"
