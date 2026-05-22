# NVidia GPU

sudo dnf config-manager addrepo --from-repofile https://developer.download.nvidia.com/compute/cuda/repos/fedora43/x86_64/cuda-fedora43.repo
sudo dnf clean all
sudo dnf -y install cuda-toolkit-13-2

# Install NVidia Open Driver
# sudo dnf -y install nvidia-open