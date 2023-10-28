-- specify different tab widths on certain files
vim.api.nvim_create_augroup('setIndent', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'setIndent',
  pattern = {
    'xml',
    'html',
    'xhtml',
    'css',
    'scss',
    'javascript',
    'typescript',
    'yaml',
    'javascriptreact',
    'typescriptreact',
    'markdown',
    'lua',
  },
  command = 'setlocal shiftwidth=2 tabstop=2 softtabstop=2',
})

---> filetype configuration for miniindentscope
-- bottom whitespace trimming
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'markdown' },
  callback = function()
    vim.b.miniindentscope_config = {
      options = {
        border = 'top',
      },
    }
  end,
})
-- disabling
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'alpha', 'lazy', 'mason', 'lspinfo' },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

-- where applicable, reset cursor to blinking I-beam after closing Neovim
-- https://github.com/neovim/neovim/issues/4867
vim.api.nvim_create_augroup('resetCursor', { clear = true })
vim.api.nvim_create_autocmd('VimLeave', {
  group = 'resetCursor',
  pattern = '*',
  command = 'set guicursor=a:ver10-blinkon1',
})

-->> "RUN ONCE" ON FILE OPEN COMMANDS <<--
-- prevent comment from being inserted when entering new line in existing comment
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  callback = function()
    -- allow <CR> to continue block comments only
    -- https://stackoverflow.com/questions/10726373/auto-comment-new-line-in-vim-only-for-block-comments
    vim.schedule(function()
      -- TODO: find a way for this to work without changing comment format, to
      -- allow for automatic comment wrapping when hitting textwidth
      vim.opt_local.comments:remove('://')
      vim.opt_local.comments:remove(':--')
      vim.opt_local.comments:remove(':#')
      vim.opt_local.comments:remove(':%')
    end)
    vim.opt_local.bufhidden = 'delete'
  end,
})

-- lazy load keymaps and user-defined commands
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  once = true,
  callback = function()
    require('bindings')
  end,
})

-- load EZ-Semicolon upon entering insert mode
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  once = true,
  callback = function()
    require('ezsemicolon')
  end,
})

-- open dashboard when in a directory
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if vim.fn.isdirectory(vim.fn.expand('%')) == 1 then
      vim.cmd.NvimTreeToggle(vim.fn.expand('%'))
    end
  end,
})

-- close nvim tree if last buffer of tab/window
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('NvimTreeClose', { clear = true }),
  pattern = 'NvimTree_*',
  callback = function()
    local layout = vim.api.nvim_call_function('winlayout', {})
    if
      layout[1] == 'leaf'
      and vim.api.nvim_buf_get_option(
        vim.api.nvim_win_get_buf(layout[2]),
        'filetype'
      ) == 'NvimTree'
      and layout[3] == nil
    then
      vim.cmd.quit { mods = { confirm = true } }
    end
  end,
})

-- handle dashboard animation starting and stopping
vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
  pattern = '*',
  callback = function()
    local ft = vim.bo.filetype
    if ft == 'alpha' then
      require('utils').color_fade_start()
    else
      require('utils').color_fade_stop()
    end
  end,
})

-- prevent weird snippet jumping behavior
-- https://github.com/L3MON4D3/LuaSnip/issues/258
vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = { 's:n', 'i:*' },
  callback = function()
    local ls = require('luasnip')
    if
      ls.session.current_nodes[vim.api.nvim_get_current_buf()]
      and not ls.session.jump_active
    then
      ls.unlink_current()
    end
  end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local util = require('utils')
    for i = 1, 8, 1 do
      vim.api.nvim_set_hl(0, 'FoldCol' .. i, {
        bg = util.blend(
          string.format(
            '#%06x',
            vim.api.nvim_get_hl(0, { name = 'Normal' }).fg or 0
          ),
          string.format(
            '#%06x',
            vim.api.nvim_get_hl(0, { name = 'Normal' }).bg or 0
          ),
          0.125 * i
        ),
        fg = vim.api.nvim_get_hl(0, { name = 'Function' }).fg or 0,
      })
    end
  end,
})
