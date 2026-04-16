#!/bin/bash
# Configures firewalld to allow only local network communication.
# All traffic to/from the internet is blocked; LAN and loopback remain open.

set -euo pipefail

if ! systemctl is-active --quiet firewalld; then
    sudo systemctl enable --now firewalld
fi

# Drop all existing rich rules and reset to a clean block-all default
sudo firewall-cmd --set-default-zone=block

# Allow loopback
sudo firewall-cmd --permanent --zone=trusted --add-interface=lo

# Allow RFC-1918 private address ranges (LAN only)
sudo firewall-cmd --permanent --zone=trusted --add-source=10.0.0.0/8
sudo firewall-cmd --permanent --zone=trusted --add-source=172.16.0.0/12
sudo firewall-cmd --permanent --zone=trusted --add-source=192.168.0.0/16

# Apply changes
sudo firewall-cmd --reload

echo "Firewall configured: only local network traffic is allowed."
echo "Active zones:"
sudo firewall-cmd --get-active-zones
