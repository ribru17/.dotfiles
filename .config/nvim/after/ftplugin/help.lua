-- easier navigation
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.signcolumn = 'no'
-- better mnemonic for tag jumping
vim.keymap.set({ 'n', 'x' }, 'gd', '<C-]>', {
  buffer = true,
})
