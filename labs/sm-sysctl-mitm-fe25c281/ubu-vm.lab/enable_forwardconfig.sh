#!/usr/bin/env bash

if [ -z "$SUDO_USER" ]; then
	echo "Use Sudo"
	exit 1
fi

#Enable kernel parameter for forwarding
sysctl -w net.ipv4.ip_forward=1 > /dev/null
sysctl -p
echo "Kernel parameter enabled"

#enable firewall forward
iptables -P  FORWARD ACCEPT  
echo "iptable updated"
