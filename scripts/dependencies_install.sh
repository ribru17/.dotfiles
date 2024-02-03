#!/bin/bash

# Installs system dependencies.
echo "Updating system:"
sudo pacman -Syu
echo "Installing dependencies:"
sudo pacman -S --needed\
    fastfetch\
    neovim\
    nodejs\
    npm\
    python3\
    kitty\
    git\
    git-delta\
    ripgrep\
    wl-clipboard\
    bat\
    reflector\
    base-devel\
    curl\
    gcc\
    unzip\
    less\
    xz\
    bash-completion
echo "Installing Yay:"
cd && git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd .. && rm -rf yay
echo "Installing blesh:"
wget -O - https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar xJf -
mkdir -p ~/.local/share/blesh
cp -Rf ble-nightly/* ~/.local/share/blesh/
rm -rf ble-nightly
source ~/.local/share/blesh/ble.sh
echo "Setting up terminfo support for WezTerm (for things like undercurl):"
tempfile=$(mktemp) \
    && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
    && tic -x -o ~/.terminfo $tempfile \
    && rm $tempfile
