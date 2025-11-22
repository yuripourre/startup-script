# Remove evolution (email client)
sudo dnf remove evolution

# Remove libreoffice suite
sudo dnf remove libreoffice*

# Disable PackageKit
gsettings set org.gnome.software download-updates false

# Disable PackageKit cache
sudo sed -i "/^KeepCache=/c KeepCache=false" /etc/PackageKit/PackageKit.conf
sudo sed -i "/^#KeepCache=/c KeepCache=false" /etc/PackageKit/PackageKit.conf

# Disable lang files other than english
grep -qF '%_install_langs   en:en_US:en_US.UTF-8' /etc/rpm/macros.lang  || echo '%_install_langs   en:en_US:en_US.UTF-8' | sudo tee --append /etc/rpm/macros.lang

# Reduce max memory for services
#sudo sed -i "/^SystemMaxUse=/c SystemMaxUse=50M" /etc/systemd/journald.conf
#sudo sed -i "/^#SystemMaxUse=/c SystemMaxUse=50M" /etc/systemd/journald.conf

