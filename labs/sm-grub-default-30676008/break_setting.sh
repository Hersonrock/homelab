#!/usr/bin/env bash

if [ -z "$SUDO_USER" ]; then
	echo "Use SUDO"
	exit 1
fi

#create a backup
cp /etc/default/grub /etc/default/grub.bak

sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="root=\/dev\/null"/' /etc/default/grub

update-grub
