
# Custom software
sudo dnf -y install wine ImageMagick xfburn transmission wings

# Install Util software
sudo dnf install -y unar p7zip xdotool

# Custom OS Style
# sudo dnf -y install gnome-tweak-tool
# sudo dnf copr -y enable region51/chrome-gnome-shell

# Software to Auto Mount HDs
sudo dnf -y install gnome-disk-utility

# Do not update Kernel Packages (Avoid VirtualBox break)
echo 'excludepkgs = kernel-*' | sudo tee --append /etc/dnf/dnf.conf

# Disable PackageKit
gsettings set org.gnome.software download-updates false

# Disable PackageKit cache
sudo sed -i 's/#KeepCache=false/KeepCache=false/' /etc/PackageKit/PackageKit.conf

# Disable lang files other than english
echo '%_install_langs   en:en_US:en_US.UTF-8' | sudo tee -a /etc/rpm/macros.lang

# Create Empty File option
touch ~/Templates/Empty\ File

# Show Minimize and Maximize buttons
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

# Show day number and seconds
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true

# Prevent screen to lock
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'

# Change screenshots folder
gsettings set "org.gnome.gnome-screenshot" "auto-save-directory" "~/Pictures"

# Change recording time to 10 minutes (ctrl+alt+shift+r)
gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 600
