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
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    event = { 'VeryLazy' },
    config = function()
      require('ufo').setup {
        preview = {
          win_config = {
            border = 'none',
            winhighlight = 'Normal:Folded',
            winblend = 0,
          },
        },
        provider_selector = function(_, filetype, _)
          -- use nested markdown folding
          if filetype == 'markdown' then
            return ''
          end
          return { 'treesitter' }
        end,
      }
    end,
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    ft = { 'html', 'clojure', 'query', 'scheme', 'commonlisp' },
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')
      require 'rainbow-delimiters.setup' {
        strategy = {
          [''] = function() return nil end,
          commonlisp = rainbow_delimiters.strategy['global'],
          scheme = rainbow_delimiters.strategy['global'],
          query = rainbow_delimiters.strategy['global'],
          clojure = rainbow_delimiters.strategy['global'],
          html = rainbow_delimiters.strategy['global'],
        },
      }
    end,
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
        surrounds = {
          ['g'] = {
            add = function()
              local result = require('nvim-surround.config').get_input(
                'Enter the generic name: ')
              return {
                { result .. '<' },
                { '>' },
              }
            end,
            find = '[%w_]-<.->',
            delete = '^([%w_]-<)().-(>)()$',
          },
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
        vim.cmd.normal { '$', bang = true }
        vim.cmd.startinsert { bang = true }
      end, {})
    end,
  },
}
