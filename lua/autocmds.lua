-- specify different tab widths on certain files
vim.api.nvim_create_augroup('setIndent', { clear = true })
vim.api.nvim_create_autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
    'yaml', 'javascriptreact', 'typescriptreact', 'markdown', 'lua',
  },
  command = 'setlocal shiftwidth=2 tabstop=2 softtabstop=2',
})

-- where applicable, reset cursor to blinking I-beam after closing Neovim
-- https://github.com/neovim/neovim/issues/4867
vim.api.nvim_create_augroup('resetCursor', { clear = true })
vim.api.nvim_create_autocmd('VimLeave', {
  group = 'resetCursor',
  pattern = '*',
  command = 'set guicursor=a:ver10-blinkon1',
})

-- prevent comment from being inserted when entering new line in existing comment
vim.api.nvim_create_autocmd('BufEnter',
  {
    callback = function()
      vim.opt.formatoptions = vim.opt.formatoptions -
          { 'c', 'r', 'o' }
    end,
  })

local lsp_formatting = function()
  vim.lsp.buf.format {
    filter = function(client)
      -- disable formatters that are already covered by null-ls to prevent conflicts
      local disabled_formatters = { 'clangd', 'tsserver', 'html' }

      for k = 1, #disabled_formatters do
        local v = disabled_formatters[k]
        if client.name == v then
          return false
        end
      end

      return true
    end,
  }
end

-- Explicitly format on save: passing this through null-ls failed with
-- unsupported formatters, e.g. html-lsp
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    lsp_formatting()
  end,
})

-- lazy load keymaps and user-defined commands
vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('LoadBinds', { clear = true }),
  pattern = 'VeryLazy',
  callback = function()
    require('bindings')
  end,
})

-- load EZ-Semicolon upon entering insert mode
vim.api.nvim_create_autocmd('InsertEnter', {
  group = vim.api.nvim_create_augroup('LoadEZSemicolon', { clear = true }),
  callback = function()
    require('ezsemicolon')
    vim.api.nvim_clear_autocmds { group = 'LoadEZSemicolon' }
  end,
})

-- open dashboard when in a directory
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if vim.fn.isdirectory(vim.fn.expand('%')) == 1 then
      require('alpha')
      vim.cmd.Alpha()
    end
  end,
})

-- prevent weird snippet jumping behavior
-- https://github.com/L3MON4D3/LuaSnip/issues/258
vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*',
  callback = function()
    if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
    then
      require('luasnip').unlink_current()
    end
  end,
})

vim.api.nvim_create_autocmd('TabClosed', {
  pattern = '*',
  callback = function()
    local i = 1
    local lastbuf = vim.fn.bufnr('$')
    local vim_fn = vim.fn
    local next = next
    while i <= lastbuf do
      if vim_fn.buflisted(i) == 1 and next(vim_fn.win_findbuf(i)) == nil then
        vim.cmd(':bd ' .. i)
      end
      i = i + 1
    end
  end,
})
