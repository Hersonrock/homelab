#!/usr/bin/env bash

if [ -z "$SUDO_USER" ]; then
	echo "Use Sudo"
	exit 1
fi

ip route del 192.168.0.42 via 192.168.0.43
ip route
echo "Route deleted"
