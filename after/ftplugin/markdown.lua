vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

vim.api.nvim_create_autocmd('BufEnter', {
  once = true,
  callback = function()
    vim.opt_local.foldexpr = 'NestedMarkdownFolds()'

    -- start with all folds open
    vim.cmd.normal { 'zR', mods = { silent = true } }
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
