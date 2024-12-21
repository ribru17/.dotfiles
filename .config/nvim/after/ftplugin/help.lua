-- easier navigation
vim.wo.relativenumber = true
vim.wo.number = true
-- better mnemonic for tag jumping
vim.keymap.set({ 'n', 'x' }, 'gd', '<C-]>', {
  buffer = true,
})
