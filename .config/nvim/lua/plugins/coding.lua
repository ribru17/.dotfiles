local BORDER_STYLE = require('rileybruins.settings').border
return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('gitsigns').setup {
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
    version = '^3',
    ft = { 'rust' },
  },
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
    -- Lazy-load netrw for `gx` functionality, *only* if `xdg-open` is not found
    -- (in which case we will create a regular keymapping for `gx` using it)
    dir = vim.env.VIMRUNTIME .. '/plugin/netrwPlugin.vim',
    enabled = function()
      return vim.fn.executable('xdg-open') == 0
    end,
    keys = {
      'gx',
    },
    cmd = 'Explore',
    config = function()
      vim.cmd.source(vim.env.VIMRUNTIME .. '/plugin/netrwPlugin.vim')
    end,
  },
  {
    'andymass/vim-matchup',
    event = { 'BufReadPost', 'BufNewFile' },
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
      ---@diagnostic disable-next-line: missing-fields
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
            border = require('rileybruins.settings').border,
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
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'x' } },
      { 'gb', mode = { 'n', 'x' } },
      { '<C-_>', mode = { 'i', 'x', 'n' } },
    },
    config = function()
      local in_jsx_tags = require('rileybruins.utils').in_jsx_tags
      ---@diagnostic disable-next-line: missing-fields
      require('Comment').setup {
        pre_hook = function()
          local ft = vim.bo.filetype
          if ft == 'typescriptreact' or ft == 'javascriptreact' then
            if
              in_jsx_tags(false)
              or vim.api.nvim_get_current_line():match('^%s-{/%*.-%*/}%s-$')
            then
              return '{/*%s*/}'
            end
          end
          ---@diagnostic disable-next-line: return-type-mismatch
          return nil
        end,
        ignore = function()
          local mode = vim.api.nvim_get_mode()['mode']
          if mode == 'n' then
            return '^$'
          end
          ---@diagnostic disable-next-line: return-type-mismatch
          return nil
        end,
      }

      -- toggle comment in insert mode
      local comment_line = require('Comment.api').toggle.linewise.current
      vim.keymap.set('i', '<C-_>', function()
        if vim.api.nvim_get_current_line() == '' then
          local esc =
            vim.api.nvim_replace_termcodes('<Esc>gcA', true, false, true)
          vim.api.nvim_feedkeys(esc, 'm', false)
          return
        end
        comment_line()
        vim.cmd.normal { '$', bang = true }
        vim.cmd.startinsert { bang = true }
      end, {})
      vim.keymap.set({ 'n' }, '<C-_>', comment_line, {})
      vim.keymap.set({ 'x' }, '<C-_>', 'gc', { remap = true })
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
          typescript = { 'deno_fmt' },
          typescriptreact = { 'deno_fmt' },
        },
      }
    end,
  },
}
