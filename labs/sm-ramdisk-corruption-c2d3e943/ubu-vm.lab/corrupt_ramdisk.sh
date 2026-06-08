#!/usr/bin/env bash

if [ -z "$SUDO_USER" ]; then
	echo "Use Sudo"
	exit 1
fi

cp /boot/initrd.img-$(uname -r) /boot/initrd.img-$(uname -r).bak
truncate -s 0 /boot/initrd.img-$(uname -r)
stat /boot/initrd.img-$(uname -r)
