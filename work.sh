# Install Chromium
sudo dnf -y install chromium

# Install Zoom
wget https://zoom.us/client/latest/zoom_x86_64.rpm -O zoom.rpm
sudo dnf -y localinstall zoom.rpm
