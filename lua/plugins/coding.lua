return {
  {
    'echasnovski/mini.indentscope',
    version = '*',
    main = 'mini.indentscope',
    event = { 'VeryLazy' },
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
    event = { 'VeryLazy' },
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
    -- lazy-load netrw for `gx` functionality
    dir = vim.env.VIMRUNTIME .. '/plugin/netrwPlugin.vim',
    keys = {
      'gx',
    },
    cmd = 'Explore',
    config = function()
      vim.cmd.source(vim.env.VIMRUNTIME .. '/plugin/netrwPlugin.vim')
    end,
  },
  {
    -- lazy-load matchit
    dir = vim.env.VIMRUNTIME .. '/plugin/matchit.vim',
    keys = {
      '%',
      'g%',
      ']%',
      '[%',
      { 'a%', mode = { 'x' } },
    },
    config = function()
      vim.cmd.packadd('matchit')
      -- after packadd, buffers do not know we have matchit so we must tell them
      -- https://www.reddit.com/r/vim/comments/5jasry/clean_reloading_of_buffers_after_packadd/
      vim.cmd.doautoall('BufRead')
    end,
  },
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
    dependencies = {
      'kevinhwang91/promise-async',
      -- remove digits from fold column
      -- https://github.com/kevinhwang91/nvim-ufo/issues/4
      {
        'luukvbaal/statuscol.nvim',
        config = function()
          local builtin = require('statuscol.builtin')
          local c = require('statuscol.ffidef').C
          require('statuscol').setup {
            relculright = true,
            segments = {
              { text = { '%s' }, click = 'v:lua.ScSa' },
              { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
              {
                text = {
                  function(args)
                    local foldinfo = c.fold_info(args.wp, args.lnum)
                    local level = foldinfo.level
                    local width = c.compute_foldcolumn(args.wp, 0)
                    if width == 0 then
                      return ''
                    end
                    local hl = '%#FoldCol' .. level .. '#'
                    if level == 0 then
                      hl = '%#Normal#'
                    end
                    if level > 8 then
                      hl = '%#FoldCol8#'
                    end
                    return hl .. ' %#Normal# '
                  end,
                },
                click = 'v:lua.ScFa',
              },
            },
          }
        end,
      },
    },
    event = { 'VeryLazy' },
    config = function()
      local ufo = require('ufo')
      ufo.setup {
        fold_virt_text_handler = function(
          virtText,
          lnum,
          endLnum,
          width,
          truncate
        )
          local newVirtText = {}
          local totalLines = vim.api.nvim_buf_line_count(0) - 1
          local foldedLines = endLnum - lnum
          local suffix = (' ⤶ %d %d%%'):format(
            foldedLines,
            foldedLines / totalLines * 100
          )
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          table.insert(virtText, { ' …', 'Comment' })
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              -- str width returned from truncate() may less than 2nd argument, need padding
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix
                  .. (' '):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          local rAlignAppndx = math.max(
            math.min(vim.opt.textwidth['_value'], width - 1)
              - curWidth
              - sufWidth,
            0
          )
          suffix = (' '):rep(rAlignAppndx) .. suffix
          table.insert(newVirtText, { suffix, 'MoreMsg' })
          return newVirtText
        end,
        preview = {
          win_config = {
            border = require('settings').border,
            winhighlight = 'Normal:Normal',
            winblend = 0,
          },
        },
        provider_selector = function(_, _, _)
          return { 'treesitter' }
        end,
      }

      local map = vim.keymap.set
      map('n', 'zR', ufo.openAllFolds)
      map('n', 'zM', ufo.closeAllFolds)
      map('n', 'zk', ufo.goPreviousStartFold)
      map('n', 'zn', ufo.goNextClosedFold)
      map('n', 'zp', ufo.goPreviousClosedFold)
    end,
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    ft = { 'html', 'clojure', 'query', 'scheme', 'commonlisp' },
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')
      require('rainbow-delimiters.setup').setup {
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
    version = '*',
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
    commit = 'e76ad83e4a3e303ccf50104a251118613162f8a8',
    event = { 'BufWritePre' },
    cmd = 'ConformInfo',
    config = function()
      -- use this directory's stylua.toml if none is found in the current
      require('conform.formatters.stylua').env = {
        XDG_CONFIG_HOME = vim.fn.expand('~/.config/nvim/'),
      }
      require('conform.formatters.injected').options.ignore_errors = true
      local util = require('conform.util')
      local deno_fmt = require('conform.formatters.deno_fmt')
      local clang_format = require('conform.formatters.clang_format')
      util.add_formatter_args(deno_fmt, { '--single-quote' }, { append = true })
      util.add_formatter_args(clang_format, {
        '--style',
        '{IndentWidth: 4, AllowShortFunctionsOnASingleLine: Empty}',
      })
      require('conform').setup {
        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = true,
          quiet = true,
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
