#!/usr/bin/env bash

if [ -z "$SUDO_USER" ]; then
	echo "Run with sudo"
	exit 1
fi

apt install -y curl

