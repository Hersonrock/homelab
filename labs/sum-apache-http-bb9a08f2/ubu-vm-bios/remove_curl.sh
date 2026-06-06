#!/usr/bin/env bash

if [ -z $SUDO_USER ]; then
	echo "Use sudo"
	exit 1
fi

apt remove -y curl

