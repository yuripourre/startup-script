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
$SETTINGS/custom3/ name "Open IntelliJ"
$SETTINGS/custom3/ command "sh idea-IC/bin/idea.sh"
$SETTINGS/custom3/ binding "<Primary>F9"

# Open Adobe Fireworks
$SETTINGS/custom4/ name "Open Fireworks"
$SETTINGS/custom4/ command "wine /opt/nonfree/fireworks/Fireworks.exe"
$SETTINGS/custom4/ binding "<Primary>F8"

# Open Android Studio
$SETTINGS/custom5/ name "Open Android Studio"
$SETTINGS/custom5/ command "sh android-studio/bin/studio.sh"
$SETTINGS/custom5/ binding "<Primary>F10"

# Simulate Left Click (Ctrl + Single Quote)
$SETTINGS/custom6/ name "Left Click"
$SETTINGS/custom6/ command "xdotool click 1"
$SETTINGS/custom6/ binding "<Control>apostrophe"

# Simulate Right Click (Ctrl + 1)
$SETTINGS/custom7/ name "Right Click"
$SETTINGS/custom7/ command "xdotool click 3"
$SETTINGS/custom7/ binding "<Control>1"

# List all bindings
# dconf dump /
