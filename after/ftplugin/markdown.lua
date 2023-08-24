vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

-- NestedMarkdownFolds() doesn't refresh against telescope folding bug
-- reference: https://github.com/nvim-treesitter/nvim-treesitter/issues/4754
vim.api.nvim_create_autocmd('BufEnter', {
  once = true,
  callback = function()
    vim.cmd.normal('zx')
  end,
})

require('nvim-surround').buffer_setup {
  aliases = {
    ['b'] = { '{', '[', '(', '<', 'b' },
  },
  surrounds = {
    ['b'] = {
      add = { '**', '**' },
      find = '%*%*.-%*%*',
      delete = '^(%*%*)().-(%*%*)()$',
    },
  },
}
