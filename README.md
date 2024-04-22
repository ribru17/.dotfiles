# My Dotfiles :floppy_disk:

Dotfiles for NixOS.

## Installation

To install, run:

```sh
nix-shell -p git bash wget
wget -O - https://raw.githubusercontent.com/ribru17/.dotfiles/master/scripts/dotfiles_install.sh | bash
```

This script will download all files, regenerate the hardware configuration, and
set up everything to be tracked in the Git repo.

## Usage

System configuration is found in `~/.config/nixos/`, and can be rebuilt with the
`nix:rebuild` command. Flake inputs can be updated with `nix:update`.

Remember to update the `nixos-hardware` device property name in `flake.nix`.

## Reference

Credit to [this article](https://www.atlassian.com/git/tutorials/dotfiles) for
getting me started!
