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
      { mode = 'n', '<C-_>' },
      { mode = 'x', '<C-_>' },
      'gc',
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
    end,
  },
  {
    'ribru17/nvim-ts-autotag',
    ft = { 'html', 'xml', 'javascript', 'typescript', 'javascriptreact',
      'typescriptreact', 'svelte', 'vue', 'tsx',
      'jsx', 'rescript', 'php', 'glimmer', 'handlebars', 'hbs',
      -- 'markdown', -- plugin does not work for markdown files (despite claiming to)
    },
  },
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
  },
}
