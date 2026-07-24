# Map buttons as separate inputs
sudo tee /etc/udev/rules.d/99-keyboards.rules > /dev/null <<'EOF'
SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_PATH}=="pci-0000:00:14.0-usb-0:3:1.1", SYMLINK+="input/button-red"
SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_PATH}=="pci-0000:00:14.0-usb-0:1:1.1", SYMLINK+="input/button-green"
EOF

sudo udevadm control --reload-rules
sudo udevadm trigger

# Red Button 
# Create keyd conf
sudo tee /etc/keyd/red-button.conf > /dev/null <<'EOF'
[ids]
2704:2018

[main]
enter = coffee
EOF
