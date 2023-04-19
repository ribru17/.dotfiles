vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

vim.cmd [[silent exe "normal zR"]]

-- disable EZ-Semicolon for markdown files
vim.keymap.set('i', ';', ';', { remap = false, buffer = 0 })
