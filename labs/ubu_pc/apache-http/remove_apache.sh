#!/usr/bin/env bash

if [ -z "$SUDO_USER" ]; then

	echo "Run with sudo"
	exit 1
fi

systemctl stop apache2
apt remove -y apache2
echo ""  > /var/www/html/index.html
echo "Uninstall complete"
