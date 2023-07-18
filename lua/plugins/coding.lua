return {
  {
    'tpope/vim-fugitive',
    cmd = 'Git',
  },
  {
    'tpope/vim-abolish',
    cmd = 'S',
  },
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
  },
  {
    'HiPhish/nvim-ts-rainbow2',
    lazy = true,
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
        aliases = {
          ['d'] = { '{', '[', '(', '<', '"', "'", '`' }, -- any delimiter
          ['b'] = { '{', '[', '(', '<' },                -- bracket
          ['p'] = { '(' },
        },
        move_cursor = false,
      }
    end,
  },
  {
    'numToStr/Comment.nvim',
    keys = {
      { mode = { 'i', 'n', 'x' }, '<C-_>' },
      'gb',
    },
    config = function()
      require('Comment').setup {
        toggler = {
          line = '<C-_>',
        },
        opleader = {
          line = '<C-_>',
        },
        ignore = function()
          local mode = vim.api.nvim_get_mode()['mode']
          if mode == 'n' then
            return '^$'
          end
          return nil
        end,
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim')
            .create_pre_hook(),
      }

      -- toggle comment in insert mode
      local api = require('Comment.api')
      vim.keymap.set('i', '<C-_>', function()
        api.toggle.linewise.current()
        vim.cmd('normal! $')
        vim.cmd([[startinsert!]])
      end, {})
    end,
  },
}
