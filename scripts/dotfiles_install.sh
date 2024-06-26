#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash git cowsay

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
    fi
fi
echo "Building system:"
nixos-generate-config --show-hardware-config > "$HOME/.config/nixos/hardware-configuration.nix"
sudo nixos-rebuild switch --flake "$HOME/.config/nixos/"
betterdiscordctl install
cowsay 'Done!'
