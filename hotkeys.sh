# Custom keyboard shortcuts
SETTINGS="gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
"['$KEY_PATH/custom0/', \
 '$KEY_PATH/custom1/', \
 '$KEY_PATH/custom2/', \
 '$KEY_PATH/custom3/', \
 '$KEY_PATH/custom4/', \
 '$KEY_PATH/custom5/', \
 '$KEY_PATH/custom6/', \
 '$KEY_PATH/custom7/']"

# Launch Terminal
$SETTINGS/custom0/ name "Open Terminal"
$SETTINGS/custom0/ command "gnome-terminal"
$SETTINGS/custom0/ binding "<Primary>F2"

# Open up file manager
$SETTINGS/custom1/ name "Open File Manager"
$SETTINGS/custom1/ command "/usr/bin/nautilus --new-window"
$SETTINGS/custom1/ binding "<Primary><Alt>E"

# Open browser
$SETTINGS/custom2/ name "Open Browser"
$SETTINGS/custom2/ command "/usr/bin/firefox"
$SETTINGS/custom2/ binding "<Primary><Alt>I"

# Open IntelliJ
$SETTINGS/custom3/ name "Open Cursor"
$SETTINGS/custom3/ command "./cursor/Cursor.AppImage"
$SETTINGS/custom3/ binding "<Primary>F9"

# Open Adobe Fireworks
$SETTINGS/custom4/ name "Open Fireworks"
$SETTINGS/custom4/ command "wine /opt/nonfree/fireworks/Fireworks.exe"
$SETTINGS/custom4/ binding "<Primary>F8"

# Open Android Studio
$SETTINGS/custom5/ name "Open Android Studio"
$SETTINGS/custom5/ command "sh android-studio/bin/studio.sh"
$SETTINGS/custom5/ binding "<Primary>F10"

# Open Text Editor
$SETTINGS/custom6/ name "Open Text Editor"
$SETTINGS/custom6/ command "/usr/bin/gnome-text-editor"
$SETTINGS/custom6/ binding "<Primary><Alt>T"

# Open System Monitor (Ctrl + Alt + Del)
$SETTINGS/custom7/ name "Open System Monitor"
$SETTINGS/custom7/ command "gnome-system-monitor"
$SETTINGS/custom7/ binding "<Primary><Alt>Delete"

# List all bindings
# dconf dump /

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
f13 = C-c
f14 = C-v
f15 = C-S-v
f16 = C-x

[leftctrl]
1 = leftmouse
2 = middlemouse
3 = rightmouse
EOF

# Enable + restart keyd service
sudo systemctl enable keyd
sudo keyd reload
# Check key codes
# sudo keyd monitor
