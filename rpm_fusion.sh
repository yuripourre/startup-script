# https://fedoraproject.org/wiki/Workstation/Third_Party_Software_Repositories
sudo dnf install -y fedora-workstation-repositories

# Install RPM fusion repos (old fashion way)
#sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
