# Quakespasm
wget http://sourceforge.net/projects/quakespasm/files/Linux/quakespasm-0.93.1_amd64.tar.gz/download -O quakespasm.tar.gz
tar zvxf quakespasm.tar.gz
sudo dnf install wine
wget http://www.quakeone.com/q1files/downloads/quake-shareware-setup-beta099a.exe -O quake.exe
wine quake.exe
# Manual Action Required

cd quakespasm-*
mkdir -p id1
cp ~/.wine/drive_c/quake/id1/pak0.pak id1

rm quake.exe
rm quakespasm.tar.gz

# Reference
# https://www.addictivetips.com/ubuntu-linux-tips/play-quake-1-on-linux/
