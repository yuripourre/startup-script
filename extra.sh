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
sudo sed -i "/IgnoreLid=/c IgnoreLid=true" /etc/UPower/UPower.conf

# Fedora 39 and Over
sudo sed -i "/HandleLidSwitch=/c HandleLidSwitch=ignore" /usr/lib/systemd/logind.conf
sudo sed -i "/HandleLidSwitchExternalPower=/c HandleLidSwitchExternalPower=ignore" /usr/lib/systemd/logind.conf
sudo sed -i "/HandleLidSwitchDocked=/c HandleLidSwitchDocked=ignore" /usr/lib/systemd/logind.conf

# Change screenshots folder (Removed in newer Fedora versions)
#gsettings set "org.gnome.gnome-screenshot" "auto-save-directory" "~/Pictures"

# Change recording time to 10 minutes (ctrl+alt+shift+r)  (Removed in newer Fedora versions)
#gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 600

# Do not update Kernel Packages (avoid VirtualBox breakage)
EXCLUDE_PACKAGES="kernel-*"
grep -qF "excludepkgs=$EXCLUDE_PACKAGES" /etc/dnf/dnf.conf  || echo "excludepkgs=$EXCLUDE_PACKAGES" | sudo tee --append /etc/dnf/dnf.conf

# Increase number of retained kernels to 8
export RETAINED_KERNELS_CONFIG=installonly_limit
export NUM_KERNELS=8
export DNF_CONFIG=/etc/dnf/dnf.conf

sed -Ei "s/(installonly_limit=).*/\1$NUM_KERNELS/" /etc/dnf/dnf.conf
