#!/bin/bash
set -e
USER_NAME=$(logname 2>/dev/null || echo $SUDO_USER)
CONFIG_FILE="/etc/gdm/custom.conf"

# Create backup
sudo cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"

# Enable AutomaticLoginEnable
if grep -q "^AutomaticLoginEnable=" "$CONFIG_FILE"; then
  sudo sed -i "s/^AutomaticLoginEnable=.*/AutomaticLoginEnable=true/" "$CONFIG_FILE"
elif grep -q "^#AutomaticLoginEnable=" "$CONFIG_FILE"; then
  sudo sed -i "s/^#AutomaticLoginEnable=.*/AutomaticLoginEnable=true/" "$CONFIG_FILE"
else
  # Add after [daemon] section header
  sudo sed -i "/^\[daemon\]/a AutomaticLoginEnable=true" "$CONFIG_FILE"
fi

# Set AutomaticLogin username
if grep -q "^AutomaticLogin=" "$CONFIG_FILE"; then
  sudo sed -i "s/^AutomaticLogin=.*/AutomaticLogin=$USER_NAME/" "$CONFIG_FILE"
elif grep -q "^#AutomaticLogin=" "$CONFIG_FILE"; then
  sudo sed -i "s/^#AutomaticLogin=.*/AutomaticLogin=$USER_NAME/" "$CONFIG_FILE"
else
  # Add after [daemon] section header (or after AutomaticLoginEnable if it exists)
  if grep -q "^AutomaticLoginEnable=" "$CONFIG_FILE"; then
    sudo sed -i "/^AutomaticLoginEnable=/a AutomaticLogin=$USER_NAME" "$CONFIG_FILE"
  else
    sudo sed -i "/^\[daemon\]/a AutomaticLogin=$USER_NAME" "$CONFIG_FILE"
  fi
fi