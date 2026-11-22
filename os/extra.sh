# Create Empty File option
touch ~/Templates/Empty\ File

# Show Minimize and Maximize buttons
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

# Show day of the week, number and seconds
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-show-weekday true

# Prevent screen to lock
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'
# Prevent closing lid to suspend
if [ -f /etc/UPower/UPower.conf ]; then
    sudo sed -i "/IgnoreLid=/c IgnoreLid=true" /etc/UPower/UPower.conf
fi

# Use a logind drop-in (survives systemd updates and works regardless of
# where the distro ships the default logind.conf)
sudo mkdir -p /etc/systemd/logind.conf.d
sudo tee /etc/systemd/logind.conf.d/90-ignore-lid.conf > /dev/null << 'EOF'
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF
# Apply without reboot (SIGHUP reloads config, does not end sessions)
sudo systemctl kill -s HUP systemd-logind

# Change screenshots folder (Removed in newer Fedora versions)
#gsettings set "org.gnome.gnome-screenshot" "auto-save-directory" "~/Pictures"

# Change recording time to 10 minutes (ctrl+alt+shift+r)  (Removed in newer Fedora versions)
#gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 600

# Increase number of retained kernels to 8
export RETAINED_KERNELS_CONFIG=installonly_limit
export NUM_KERNELS=8
export DNF_CONFIG=/etc/dnf/dnf.conf

sudo sed -Ei "s/(installonly_limit=).*/\1$NUM_KERNELS/" /etc/dnf/dnf.conf
