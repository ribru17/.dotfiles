# My init.lua

This is mostly for backup purposes as my config is very disorganized and I don't
recommend anyone take influence from it.

![neovim](https://user-images.githubusercontent.com/55766287/222920744-73644efd-b7fa-4876-85f9-b1bec5706782.png)

## Prerequisites

- Install [vim-plug](https://github.com/junegunn/vim-plug)
- In Neovim run `:PlugInstall`
- _**Optional**_ Use a font that is patched with the
  [Nerd Fonts library](https://github.com/ryanoasis/nerd-fonts) for statusline,
  bufferline icons
- _**Optional**_ Install [ripgrep](https://github.com/BurntSushi/ripgrep) for
  fuzzy finding files with keyword search
- _**Optional**_ Install yarn (`npm i -g yarn`) for `markdown-preview.nvim`
- _**Optional**_ Install
  [Deno](https://deno.land/manual@v1.31.1/getting_started/installation) for code
  formatting via `deno fmt`
- _**Optional**_ Install `clang_format` via Mason for C, C++ formatting. Most
  other LSP's have formatting configured also but the default configuration of
  `clangd` is not extensible with `null-ls`
- _**Optional**_ Install
  [`wl-clipboard`](https://archlinux.org/packages/community/x86_64/wl-clipboard/)
  (or [build from source](https://github.com/bugaevc/wl-clipboard)) if using
  Wayland in order to support yanking to the system clipboard.
