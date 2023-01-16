# EXPERIMENTAL! USE AT YOUR OWN RISK

#https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#fedora
#https://stackoverflow.com/a/16871488

sudo rpm --erase gpg-pubkey-7fa2af80*
source /etc/os-release
distro=$VERSION_ID

sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/fedora$distro/x86_64/cuda-fedora$distro.repo

# Install NVidia drivers
sudo dnf module install nvidia-driver:latest-dkms

# Disabling RPM Fusion
sudo dnf --disablerepo="rpmfusion-nonfree*" install cuda

sudo grub2-mkconfig -o /boot/grub2/grub.cfg

sudo reboot

# Remaining Steps (TODO)
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions
