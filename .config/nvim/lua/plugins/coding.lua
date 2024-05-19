local BORDER_STYLE = require('rileybruins.settings').border
return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'LazyFile' },
    config = function()
      require('gitsigns').setup {
        attach_to_untracked = true,
        signs = {
          change = { text = '┋' },
          delete = { text = '🢒' },
        },
        sign_priority = 0,
        preview_config = {
          border = BORDER_STYLE,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- next/prev git changes
          map({ 'n', 'x' }, '<leader>gj', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })

          map({ 'n', 'x' }, '<leader>gk', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })

          -- git preview
          map('n', '<leader>gp', gs.preview_hunk)
          -- git blame
          map('n', '<leader>gb', function()
            gs.blame_line { full = true }
          end)
          -- undo git change
          map('n', '<leader>gu', gs.reset_hunk)
          map('x', '<leader>gu', function()
            gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
          end)
          -- undo all git changes
          map('n', '<leader>gr', gs.reset_buffer)
          -- stage git changes
          map('n', '<leader>ga', gs.stage_hunk)
          map('x', '<leader>ga', function()
            gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
          end)
          -- unstage git changes
          map('n', '<leader>gU', gs.undo_stage_hunk)
        end,
      }
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    ft = { 'rust' },
  },
  {
    'echasnovski/mini.indentscope',
    main = 'mini.indentscope',
    event = { 'LazyFile' },
    opts = {
      symbol = '┊',
      mappings = {
        goto_top = '<leader>k',
        goto_bottom = '<leader>j',
      },
      options = {
        try_as_border = true,
      },
      draw = {
        animation = function()
          return 0
        end,
      },
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'LazyFile' },
    main = 'ibl',
    opts = {
      indent = {
        char = '┊',
        smart_indent_cap = true,
      },
      scope = {
        enabled = false,
      },
    },
  },
  {
    'andymass/vim-matchup',
    event = { 'BufReadPost', 'BufNewFile' },
  },
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G' },
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
    'HiPhish/rainbow-delimiters.nvim',
    ft = {
      'html',
      'clojure',
      'query',
      'scheme',
      'lisp',
      'commonlisp',
      'php',
      'javascriptreact',
      'typescriptreact',
    },
    config = function()
      require('rainbow-delimiters.setup').setup {
        query = {
          [''] = '',
          javascript = 'rainbow-tags-react',
          tsx = 'rainbow-tags-react',
          commonlisp = 'rainbow-delimiters',
          scheme = 'rainbow-delimiters',
          query = 'rainbow-delimiters',
          clojure = 'rainbow-delimiters',
          html = 'rainbow-delimiters',
        },
      }
    end,
  },
  {
    'kylechui/nvim-surround',
    keys = {
      'ys',
      'yS',
      'cs',
      'ds',
      { 's', 'S', remap = true, mode = { 'x' } },
      { 'S', mode = { 'x' } },
      { 'gS', mode = { 'x' } },
      { '<C-g>s', mode = { 'i' } },
      { '<C-g>S', mode = { 'i' } },
    },
    config = function()
      local input = require('nvim-surround.input').get_input
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
        aliases = {
          ['d'] = { '{', '[', '(', '<', '"', "'", '`' }, -- any delimiter
          ['b'] = { '{', '[', '(', '<' }, -- bracket
          ['p'] = { '(' },
        },
        surrounds = {
          ---@diagnostic disable-next-line: missing-fields
          ['f'] = {
            change = {
              --> INJECT: luap
              target = '^.-([%w_.]+!?)()%(.-%)()()$',
              replacement = function()
                local result = input('Enter the function name: ')
                if result then
                  return { { result }, { '' } }
                end
              end,
            },
          },
          ---@diagnostic disable-next-line: missing-fields
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
            --> INJECT: luap
            find = '[%w_]-<.->',
            --> INJECT: luap
            delete = '^([%w_]-<)().-(>)()$',
          },
          ---@diagnostic disable-next-line: missing-fields
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
            --> INJECT: luap
            find = '[%w_]-<.->',
            --> INJECT: luap
            delete = '^([%w_]-<)().-(>)()$',
          },
        },
        move_cursor = false,
      }
    end,
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = 'ConformInfo',
    config = function()
      -- use this directory's stylua.toml if none is found in the current
      require('conform.formatters.stylua').env = {
        XDG_CONFIG_HOME = vim.fn.stdpath('config'),
      }
      require('conform.formatters.injected').options.ignore_errors = true
      local util = require('conform.util')
      local clang_format = require('conform.formatters.clang_format')
      local deno_fmt = require('conform.formatters.deno_fmt')
      local shfmt = require('conform.formatters.shfmt')
      util.add_formatter_args(clang_format, {
        '--style',
        '{IndentWidth: 4, AllowShortFunctionsOnASingleLine: Empty}',
      })
      util.add_formatter_args(deno_fmt, { '--single-quote' }, { append = true })
      util.add_formatter_args(shfmt, {
        '--indent',
        '4',
        -- Case Indentation
        '-ci',
        -- Space after Redirect carets (`foo > bar`)
        '-sr',
      })
      require('conform').setup {
        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = true,
          quiet = true,
        },
        formatters_by_ft = {
          c = { 'clang_format' },
          cpp = { 'clang_format' },
          css = { 'prettierd' },
          html = { 'prettierd' },
          javascript = { 'deno_fmt' },
          javascriptreact = { 'deno_fmt' },
          json = { 'deno_fmt' },
          jsonc = { 'deno_fmt' },
          lua = { 'stylua' },
          luau = { 'stylua' },
          markdown = { 'deno_fmt' },
          python = { 'yapf' },
          sh = { 'shfmt' },
          typescript = { 'deno_fmt' },
          typescriptreact = { 'deno_fmt' },
        },
      }
    end,
  },
}
