# My Dotfiles :floppy_disk:

Dotfiles for NixOS.

## :package: Installation

To install, run:

```sh
nix-shell -p wget
wget -O - https://raw.githubusercontent.com/ribru17/.dotfiles/master/scripts/dotfiles_install.sh | sh
```

This script will download all files, regenerate the hardware configuration, and
set up everything to be tracked in the Git repo.

## :rocket: Usage

System configuration is found in `~/.config/nixos/`, and can be rebuilt with the
`nix:rebuild` command. Flake inputs can be updated with `nix:update`.

Remember to update the `nixos-hardware` device property name in `flake.nix`.

## :camera: Screenshots

![dots_dashboard_showcase](https://github.com/ribru17/.dotfiles/assets/55766287/f4b67b79-fa22-4aa5-b84a-9b8435f689b2)

![dots_md_showcase](https://github.com/ribru17/.dotfiles/assets/55766287/80b4d8b3-8b07-44c6-bcd0-899a4542c00a)

![dots_code_showcase](https://github.com/ribru17/.dotfiles/assets/55766287/f1409bd1-2c93-4dce-bcad-75e5145a8e12)

## :link: Reference

Credit to [this article](https://www.atlassian.com/git/tutorials/dotfiles) for
getting me started!
