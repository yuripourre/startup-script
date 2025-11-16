# Remap Special Keys
sudo dnf install gcc make git systemd-devel libevdev-devel
git clone https://github.com/rvaiya/keyd.git
cd keyd
make
sudo make install
cd -
rm -Rf keyd

# Install dependencies if needed
if ! command -v keyd >/dev/null 2>&1; then
  echo "keyd not found, installing from source..."
  sudo dnf install -y gcc make git systemd-devel libevdev-devel || true
  git clone https://github.com/rvaiya/keyd.git /tmp/keyd
  cd /tmp/keyd
  make
  sudo make install
fi

# Create config directory if missing
sudo mkdir -p /etc/keyd

# Write config file
sudo tee /etc/keyd/default.conf > /dev/null <<'EOF'
[ids]
*

[main]
mouse1 = pageup
mouse2 = pagedown
volumeup = pageup
volumedown = pagedown
mute = f24
f13 = C-c
f14 = C-v
f15 = C-S-v
f16 = C-x

[leftcontrol]
1 = leftmouse
2 = middlemouse
3 = rightmouse
EOF

# Enable + restart keyd service
sudo systemctl enable keyd
sudo keyd reload
# Check key codes
# sudo keyd monitor