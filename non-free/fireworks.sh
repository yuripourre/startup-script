[[ -d "$HOME/wine-nonfree" ]] || WINEPREFIX="$HOME/wine-nonfree" WINEARCH=win32 wine wineboot
export WINEPREFIX=$HOME/wine-nonfree
wine Fireworks.exe
