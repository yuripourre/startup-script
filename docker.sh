#https://www.linuxuprising.com/2019/11/how-to-install-and-use-docker-on-fedora.html

# Install dnf-plugins-core
#sudo dnf -y install dnf-plugins-core
#sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
#sudo dnf -y install docker-ce docker-ce-cli containerd.io
#sudo systemctl enable docker
#sudo systemctl start docker
#sudo usermod -a -G docker $USER

sudo dnf install -y moby-engine
sudo systemctl enable --now docker
sudo usermod -aG docker $(whoami)

# Testing
#docker run --rm hello-world:latest

# Docker Compose
sudo dnf -y install docker-compose

# Fix: dial unix /var/run/docker.sock: connect: permission denied.
# Optional
sudo groupadd docker
sudo usermod -aG docker ${USER}

sudo chmod 666 /var/run/docker.sock
sudo systemctl restart docker
