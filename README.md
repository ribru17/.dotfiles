# My init.lua

This is mostly for backup purposes as my config is very disorganized and I don't
recommend anyone take influence from it.

## Prerequisites

- Install [ripgrep](https://github.com/BurntSushi/ripgrep)
- Install yarn (`npm i -g yarn`) for `markdown-preview.nvim`
- In Neovim run `:PlugInstall`
- If statusline icons aren't working, make sure you have a font that is patched
  with the Nerd Fonts library
- _**Optional**_ Install
  [Deno](https://deno.land/manual@v1.31.1/getting_started/installation) for code
  formatting via `deno fmt`
- _**Optional**_ Install `clang_format` via Mason for C, C++ formatting. Most
  other LSP's have formatting configured also but the default configuration of
  `clangd` is not extensible with `null-ls`
