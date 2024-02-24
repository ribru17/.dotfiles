vim.keymap.set({ 'n', 'x' }, '<CR>', function()
  vim.cmd.ll {
    count = vim.api.nvim_win_get_cursor(0)[1],
  }
end, {
  buffer = true,
})
