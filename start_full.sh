# Run the basic setup
sh start.sh

# Misc
sh misc.sh

# Install codecs and VLC
sh multimedia.sh

# Dev Tools
sh dev/git.sh yuripourre@gmail.com "Yuri Pourre"
sh dev/gcc.sh
sh dev/opengl.sh
sh dev/cuda.sh
sh dev/keyd.sh
#sh dev/java.sh
#sh dev/javascript.sh
#sh dev/docker.sh

# Apps
#sh apps/dropbox.sh
#sh apps/chromium.sh
sh apps/obs-studio.sh

# Wine (Should run at the end because requires manual intervention)
sh wine.sh