
# Custom software
sudo dnf -y install wine ImageMagick xfburn transmission

# Artistic software
sudo dnf -y install inkscape wings

# Install Util software
sudo dnf install -y unar p7zip xdotool ghex

# Custom OS Style
# sudo dnf -y install gnome-tweak-tool
# sudo dnf copr -y enable region51/chrome-gnome-shell

# Software to Auto Mount HDs
sudo dnf -y install gnome-disk-utility

# Do not update Kernel Packages (avoid VirtualBox breakage)
EXCLUDE_PACKAGES="kernel-*"
grep -qF "excludepkgs=$EXCLUDE_PACKAGES" /etc/dnf/dnf.conf  || echo "excludepkgs=$EXCLUDE_PACKAGES" | sudo tee --append /etc/dnf/dnf.conf

# Create Empty File option
touch ~/Templates/Empty\ File

# Show Minimize and Maximize buttons
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

# Show day number and seconds
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true

# Prevent screen to lock
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'

# Prevent closing lid to suspend
sudo sed -i "/IgnoreLid=/c IgnoreLid=true" /etc/UPower/UPower.conf 

# Change screenshots folder
gsettings set "org.gnome.gnome-screenshot" "auto-save-directory" "~/Pictures"

# Change recording time to 10 minutes (ctrl+alt+shift+r)
gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 600
