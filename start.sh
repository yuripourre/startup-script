# Install rpmfusion repos
sh rpm_fusion.sh

# Setup OS in general
sh extra.sh

# Dropbox
sh dropbox.sh

# Git
sh git.sh

# Java
sh java.sh

# Docker
sh docker.sh

# Install codecs and VLC
sh multimedia.sh

# Custom keyboard shortcuts
sh hotkeys.sh

# OpenGL
sh opengl.sh

# Misc
sh misc.sh

# Shrink Reduces the OS size
sh shrink.sh

# Wine (Should run at the end because requires manual intervention)
sh wine.sh

## Optional Scripts

# Heroku
#sh heroku.sh

# NVidia
# Better way: https://fedoramagazine.org/install-nvidia-gpu/
#sh cuda.sh

# Install Adobe Flash
#sh adobe_flash.sh

# Work
# sh work.sh

# Games

## Quake 1
# sh games/quake.sh
