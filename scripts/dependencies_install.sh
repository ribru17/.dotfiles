#!/bin/bash

# Installs system dependencies.
echo "Updating system:"
sudo pacman -Syu
echo "Installing dependencies:"
sudo pacman -S --needed \
    base-devel \
    bash-completion \
    bat \
    curl \
    fastfetch \
    gcc \
    git \
    git-delta \
    kitty \
    less \
    man-db \
    neovim \
    nodejs \
    npm \
    python3 \
    reflector \
    ripgrep \
    unzip \
    wl-clipboard \
    xz

echo "Compiling bat theme:"
bat cache --build
echo "Installing Yay:"
cd && git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd .. && rm -rf yay
echo "Installing blesh:"
wget -O - https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar xJf -
mkdir -p ~/.local/share/blesh
cp -Rf ble-nightly/* ~/.local/share/blesh/
rm -rf ble-nightly
# shellcheck disable=1090
source ~/.local/share/blesh/ble.sh
echo "Setting up terminfo support for WezTerm (for things like undercurl):"
tempfile=$(mktemp) &&
    curl -o "$tempfile" https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo &&
    tic -x -o ~/.terminfo "$tempfile" &&
    rm "$tempfile"

read -rp "Are you on a laptop? (If yes, TLP will be installed to preserve battery life. Do NOT accept if you are on a desktop.) [y/N] " ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
    sudo pacman -S --needed tlp ethtool
    sudo systemctl enable tlp
    sudo systemctl start tlp
    sudo systemctl mask systemd-rfkill.service
    sudo systemctl mask systemd-rfkill.socket
fi
