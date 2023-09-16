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
      require('rainbow-delimiters.setup') {
        strategy = {
          [''] = function()
            return nil
          end,
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
          ['b'] = { '{', '[', '(', '<' }, -- bracket
          ['p'] = { '(' },
        },
        surrounds = {
          ['g'] = {
            add = function()
              local result = require('nvim-surround.config').get_input(
                'Enter the generic name: '
              )
              if result then
                return {
                  { result .. '<' },
                  { '>' },
                }
              end
            end,
            find = '[%w_]-<.->',
            delete = '^([%w_]-<)().-(>)()$',
          },
          ['G'] = {
            add = function()
              local result = require('nvim-surround.config').get_input(
                'Enter the generic name: '
              )
              if result then
                return {
                  { result .. '<' },
                  { '>' },
                }
              end
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
        pre_hook = require(
          'ts_context_commentstring.integrations.comment_nvim'
        ).create_pre_hook(),
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
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = 'ConformInfo',
    config = function()
      -- use this directory's stylua.toml if none is found in the current
      require('conform.formatters.stylua').env = {
        XDG_CONFIG_HOME = vim.fn.expand('~/.config/nvim/'),
      }
      vim.list_extend(require('conform.formatters.clang_format').args, {
        '--style',
        '{IndentWidth: 4, AllowShortFunctionsOnASingleLine: Empty}',
      })
      local deno_fmt = require('conform.formatters.deno_fmt')
      require('conform').formatters.deno_fmt =
        vim.tbl_deep_extend('force', deno_fmt, {
          args = require('conform.util').extend_args(
            deno_fmt.args,
            { '--single-quote' },
            { append = true }
          ),
        })
      require('conform').setup {
        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = true,
        },
        formatters_by_ft = {
          lua = { 'stylua' },
          luau = { 'stylua' },
          css = { 'prettierd' },
          html = { 'prettierd' },
          c = { 'clang_format' },
          cpp = { 'clang_format' },
          javascript = { 'deno_fmt' },
          typescript = { 'deno_fmt' },
          javascriptreact = { 'deno_fmt' },
          typescriptreact = { 'deno_fmt' },
          markdown = { 'deno_fmt' },
          json = { 'deno_fmt' },
          jsonc = { 'deno_fmt' },
        },
      }
    end,
  },
}
