#!/bin/bash

# make sure git is installed
if ! command -v git &> /dev/null
then
    echo "Installing git"
    sudo pacman -S git
fi
# clone and install dotfiles
git clone git@github.com:ribru17/.dotfiles.git $HOME/.dotfiles
alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dots config --local status.showUntrackedFiles no
dots checkout
if [ $? = 0 ]; then
    echo "Installed config!";
else
    echo "Must move or delete conflicting files.";
    exit
fi;
# optionally (preferably) install some system dependencies
read -p "Install all package dependencies? [Y/n] " ans
if [ -z "$ans" ] || [ "$ans" = "y" ] || [ "$ans" = "Y" ]
then
    ./install_dependencies.sh
fi
read -p 'Install a "symbols only" Nerd font? [Y/n] ' ans
if [ -z "$ans" ] || [ "$ans" = "y" ] || [ "$ans" = "Y" ]
then
    ./install_nerdicons.sh
fi
