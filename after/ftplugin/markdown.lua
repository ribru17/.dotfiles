vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'nc'
-- Allow block comments to be continued when hitting enter.
vim.opt_local.formatoptions:append('qcro')

-- NestedMarkdownFolds() doesn't refresh against telescope folding bug
-- reference: https://github.com/nvim-treesitter/nvim-treesitter/issues/4754
vim.api.nvim_create_autocmd('BufEnter', {
  once = true,
  callback = function()
    vim.cmd.normal('zx')
  end,
})

-- Allow bullets.vim and nvim-autopairs to coexist.
vim.schedule(function()
  vim.keymap.set('i', '<CR>', function()
    local pair = require('nvim-autopairs').completion_confirm()
    if pair == vim.api.nvim_replace_termcodes('<CR>', true, false, true) then
      vim.cmd.InsertNewBullet()
    else
      vim.cmd.normal { 'i' .. pair, bang = true }
    end
  end, {
    buffer = 0,
  })
end)

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
