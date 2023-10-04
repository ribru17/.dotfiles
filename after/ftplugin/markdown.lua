vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'nc'
vim.opt_local.foldcolumn = '0'
-- Allow block comments to be continued when hitting enter.
vim.opt_local.formatoptions:append('qcro')

-- Allow bullets.vim and nvim-autopairs to coexist.
vim.schedule(function()
  vim.keymap.set('i', '<CR>', function()
    local pair = require('nvim-autopairs').completion_confirm()
    if pair == vim.api.nvim_replace_termcodes('<CR>', true, false, true) then
      vim.cmd.InsertNewBullet()
    else
      vim.api.nvim_feedkeys(pair, 'n', false)
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
