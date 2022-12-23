sudo dnf install -y wine wine-common

# Install winetricks
wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sudo mv winetricks /usr/local/bin/

# Force apps to use msvcr80 and msvcr90 versions from WINE
# From: https://appdb.winehq.org/objectManager.php?sClass=version&iId=9410
touch vcrun.reg
echo "[HKEY_CURRENT_USER\Software\Wine\DllOverrides]" >> vcrun.reg
echo '"msvcr80"="native,builtin"' >> vcrun.reg
echo '"msvcr90"="native,builtin"' >> vcrun.reg
# Execute vcrun
wine regedit vcrun.reg
rm vcrun.reg

# [WARNING] This step requires manual intervention!
#Install vcrun2005 and vcrun2008
winetricks vcrun2005
winetricks vcrun2008
