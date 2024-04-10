# My Dotfiles :floppy_disk:

Dotfiles for NixOS.

## Installation

To install, ensure you have `wget`, `bash`, and `git`, then run:

```sh
wget -O - https://raw.githubusercontent.com/ribru17/.dotfiles/master/scripts/dotfiles_install.sh | bash
```

## Usage

System configuration is be found in `~/.config/nixos/`, and can be rebuilt with
the `nix:rebuild` command. Flake inputs can be updated with `nix:update`.

## Reference

Credit to [this article](https://www.atlassian.com/git/tutorials/dotfiles) for
getting me started!
