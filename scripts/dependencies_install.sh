#!/bin/bash

# Installs system dependencies.
echo "Updating system:"
sudo pacman -Syu
echo "Installing dependencies:"
sudo pacman -S --needed fastfetch neovim nodejs npm python3 kitty git git-delta ripgrep wl-clipboard bat reflector base-devel curl gcc unzip less
echo "Installing Yay:"
cd && git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd .. && rm -rf yay
echo "Installing blesh:"
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
