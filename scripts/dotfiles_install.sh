#!/bin/bash

# make sure git is installed
if ! command -v git &>/dev/null; then
    echo "Installing git"
    sudo pacman -S git
fi
# clone and install dotfiles
git clone --bare git@github.com:ribru17/.dotfiles.git "$HOME/.dotfiles"
function dots {
    git "--git-dir=$HOME/.dotfiles/" "--work-tree=$HOME" "$@"
}
dots config status.showUntrackedFiles no
# so fugitive can recognize the dotfiles working tree
# see: https://stackoverflow.com/a/66624354
dots config core.worktree "$HOME"
if ! dots checkout; then
    read -rp "Overwrite the existing files? [Y/n] " ans
    if [ -z "$ans" ] || [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        dots checkout -f
    else
        exit
    fi
else
    echo "Installed config!"
fi
# optionally (preferably) install some system dependencies
read -rp "Install all package dependencies? [Y/n] " ans
if [ -z "$ans" ] || [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
    ./install_dependencies.sh
fi
read -rp 'Install a "symbols only" Nerd font? [Y/n] ' ans
if [ -z "$ans" ] || [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
    ./install_nerdicons.sh
fi
