# Audio and Video Codecs
sudo dnf -y install gstreamer-plugins-bad gstreamer-plugins-bad-nonfree gstreamer-plugins-ugly gstreamer-ffmpeg gstreamer1-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-base-tools gstreamer1-plugins-good-extras gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-good gstreamer1-plugins-base gstreamer1 x264

# Not working
#sudo dnf -y install gstreamer-plugins-bad-free-extras

# Video Player VLC
sudo dnf -y install vlc

# Audio
sudo dnf -y install pavucontrol jack-audio-connection-kit-dbus
#sudo dnf -y ardour

# Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install OBS Studio
flatpak install flathub -y com.obsproject.Studio
