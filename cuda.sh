# Cuda 8 (Install OpenGL Dev before)
# http://developer2.download.nvidia.com/compute/cuda/8.0/secure/Prod2/docs/sidebar/CUDA_Installation_Guide_Linux.pdf?8P10GhSkDWj1qisxX8N8ommsMrciBB2HnFwh-50GP2DrBB3ZTpphGuv94AP8PB8WalRS8y8Z-3794gtB7EE23ab4-z_mDJ4THha2qCBCi0DwgdfdLJzyUs6HdIP4KAWMz-p8bKJ0AEsWRmxFMlfzROdBnzfueJWwgBB0QjoJjjuL_gKYWo6C2XPJww

sudo dnf -y install wget make gcc-c++ freeglut-devel libXi-devel libXmu-devel
sudo dnf -y install xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686
sudo dnf -y install compat-gcc-34

wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/patches/2/cuda_8.0.61.2_linux-run
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run

sudo sh cuda_8.0.61_375.26_linux-run

sudo rpm -ivh cuda*-rpm

sudo dnf clean all
sudo dnf install -y cuda-8-0 cuda-drivers

# Post Installation CUDA
echo 'export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}'>>~/.bashrc

# Copying Samples
cuda-install-samples-8.0.sh ~/cuda-samples
cd ~/cuda-samples/NVIDIA_CUDA-8.0_Samples
make 

# Download Gcc code
https://ask.fedoraproject.org/en/question/95016/fedora-24-how-do-i-install-and-change-the-default-gcc-compiler-version/

# Maybe works
# install compat-gcc-34
# export CC=gcc34
# export CXX=g++34
