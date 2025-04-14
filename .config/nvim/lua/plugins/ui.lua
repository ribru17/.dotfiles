local min = math.min
local SETTINGS = require('rileybruins.settings')
return {
  {
    'navarasu/onedark.nvim',
    lazy = true,
    config = function()
      require('onedark').setup {
        style = 'warmer',
        highlights = {
          -- make pop up windows blend better with the background
          ['FloatBorder'] = { bg = '$bg0' },
          ['NormalFloat'] = { bg = '$bg0' },
          ['NvimTreeNormal'] = { bg = '$bg0' },
          ['NvimTreeEndOfBuffer'] = { bg = '$bg0', fg = '$bg0' },
          -- prevent Lua constructor tables from being bolded
          ['@constructor.lua'] = { fg = '$yellow', fmt = 'none' },
          ['@function.builtin'] = { fg = '$orange' },
          -- italicize parameters and conditionals
          ['@parameter'] = { fmt = 'italic' },
          ['@conditional'] = { fmt = 'italic' },
          -- make comments stand out
          ['@comment'] = { fg = '$bg_yellow', fmt = 'italic' },
          -- change bracket color so that it doesn't conflict with string color
          ['TSRainbowGreen'] = { fg = '$fg' },
          -- better match paren highlights
          ['MatchParen'] = { fg = '$orange', fmt = 'bold' },
          -- better dashboard styling
        },
        diagnostics = {
          darker = false,
          -- for undercurl on wezterm:
          -- https://wezfurlong.org/wezterm/faq.html?highlight=undercur#how-do-i-enable-undercurl-curly-underlines
        },
      }
    end,
  },
  {
    url = 'git@github.com:ribru17/bamboo.nvim.git',
    lazy = false,
    priority = 1000,
    config = function()
      require('bamboo').setup {
        style = 'multiplex',
        toggle_style_key = '<leader><leader>',
        toggle_style_list = { 'multiplex', 'light', 'vulgaris' }, -- List of styles to toggle between
        diagnostics = {
          undercurl = false,
        },
        highlights = {
          ['@checked.content'] = { fg = '$grey', fmt = 'strikethrough' },
          -- TODO: Put this setting into bamboo.nvim once 0.11 drops
          ['WinBar'] = { fmt = 'underline', fg = '$light_grey', sp = '$grey' },
        },
      }
      vim.cmd.colorscheme { args = { 'bamboo' } }
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = true,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    opts = {
      integrations = {
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
      },
      custom_highlights = function(colors)
        return {
          -- make cmp item text matching easier to spot
          ['CmpItemAbbr'] = { ctermbg = 0, fg = colors.text },
          ['CmpItemAbbrMatch'] = { ctermbg = 0, fg = colors.blue },
          ['CmpItemAbbrMatchFuzzy'] = {
            ctermbg = 0,
            fg = colors.blue,
            underline = true,
          },
          -- make popup windows blend with the background better
          ['NormalFloat'] = { ctermbg = 0, bg = colors.base },
          -- better dashboard styling
        }
      end,
    },
  },
  {
    'folke/tokyonight.nvim',
    lazy = true,
  },
  {
    'akinsho/bufferline.nvim',
    config = function()
      require('bufferline').setup {
        options = {
          mode = 'tabs',
          separator_style = 'slant',
          color_icons = true,
          show_close_icon = false,
          show_buffer_close_icons = false,
          modified_icon = '•',
          diagnostics = 'nvim_lsp',
          ---@param count integer
          ---@param level string
          diagnostics_indicator = function(count, level)
            local icon = ' '
            if level:match('warn') then
              icon = ' '
            elseif level:match('hint') then
              icon = '󰌶 '
            elseif level:match('info') then
              icon = ' '
            end
            return icon .. count
          end,
        },
      }
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = { 'VeryLazy' },
    config = function()
      -- Custom statusline that shows total line number with current
      local function line_total()
        local curs = vim.api.nvim_win_get_cursor(0)
        return curs[1]
          .. '/'
          .. vim.api.nvim_buf_line_count(0)
          .. ','
          .. curs[2]
      end

      require('lualine').setup {
        sections = {
          lualine_z = { line_total },
        },
        options = {
          disabled_filetypes = {
            'alpha',
          },
          section_separators = { left = '', right = '' },
          -- component_separators = { left = '·', right = '·' },
          -- component_separators = { left = '', right = '' },
          -- component_separators = { left = '┊', right = '┊' },
        },
        extensions = {
          'nvim-tree',
        },
      }
    end,
  },
  {
    'echasnovski/mini.icons',
    event = 'VeryLazy',
    config = function()
      local MiniIcons = require('mini.icons')
      MiniIcons.setup {
        extension = {
          scm = { glyph = '󰐅', hl = 'MiniIconsGreen' },
          conf = { glyph = '󰒓', hl = 'MiniIconsGrey' },
        },
      }
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
  {
    'ibhagwan/fzf-lua',
    cmd = { 'FzfLua' },
    keys = { '<leader>fs', '<leader>ff', '<leader>fc' },
    config = function()
      local actions = require('fzf-lua.actions')
      require('fzf-lua').setup {
        fzf_colors = true,
        fzf_opts = {
          ['--cycle'] = true,
          ['--layout'] = 'default',
          ['--pointer'] = '>',
        },
        lsp = {
          preview = { layout = 'horizontal' },
          code_actions = {
            prompt = 'Code Actions: ',
            previewer = 'codeaction_native',
            preview_pager = (
              'delta --side-by-side --width=$FZF_PREVIEW_COLUMNS '
              .. "--hunk-header-style=omit"
            ),
            async_or_timeout = 1000,
            winopts = {
              width = 0.95,
              height = 0.90,
              preview = {
                layout = 'vertical',
                vertical = 'up:80%',
              },
            },
          },
        },
        keymap = {
          builtin = {
            false,
            ['<c-d>'] = 'preview-half-page-down',
            ['<c-u>'] = 'preview-half-page-up',
            ['<c-g>'] = 'preview-bottom',
          },
          fzf = {
            false,
            ['tab'] = '',
            ['ctrl-t'] = 'toggle+up',
            ['ctrl-d'] = 'preview-half-page-down',
            ['ctrl-u'] = 'preview-half-page-up',
            ['ctrl-g'] = 'preview-bottom',
          },
        },
        actions = {
          files = {
            false, -- do not inherit from defaults
            ['enter'] = actions.file_switch_or_edit,
            ['tab'] = actions.file_tabedit,
          },
        },
      }
      vim.keymap.set('n', '<leader>ff', function()
        require('fzf-lua').files { silent = true }
      end)
      vim.keymap.set('n', '<leader>fs', function()
        -- Equivalent to live_grep_native with glob support
        require('fzf-lua').live_grep_glob { silent = true, multiprocess = true }
      end)
      vim.keymap.set('n', '<leader>fc', function()
        vim.cmd.FzfLua('colorschemes')
      end)
    end,
  },
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    cmd = { 'Alpha' },
    opts = function()
      require('rileybruins.utils').update_colors()
      local dashboard = require('alpha.themes.dashboard')
      dashboard.opts.layout[1].val = 8
      local logo = {
        '      ███████████   ████ █████      ██',
        '     ████████████  ████   █████ ',
        '     ████  ███  ████     ████████ ███   ███████████',
        '    ██████████   █████████  ████████ █████ ██████████████',
        '   ████  ███  ████ ███   ███████ █████ █████ ████ █████',
        ' ██████ ███  ████ ████████████ █████ █████ ████ █████',
        '██████ ███████████████ ███n████ █████ █████ ████ ██████',
        '',
      }

      dashboard.section.header.val = logo
      dashboard.section.header.opts.hl = '@alpha.title'
      -- highlight button icon
      local function newButton(...)
        local button = dashboard.button(...)
        button.opts.hl = { { 'Special', 0, 4 } }
        return button
      end
      dashboard.section.buttons.val = {
        {
          type = 'text',
          val = ' ',
          opts = {
            position = 'center',
          },
        },
        newButton('f', ' ' .. ' Open file', ':FzfLua files<CR>'),
        newButton('r', ' ' .. ' Open recent', ':FzfLua oldfiles<CR>'),
        newButton(
          't',
          ' ' .. ' File tree',
          ':lua require("oil").toggle_float()<CR>'
        ),
        newButton(
          's',
          ' ' .. ' Search for text',
          ':FzfLua live_grep_glob multiprocess=true silent=true<CR>'
        ),
        newButton('p', '󰏗 ' .. ' Plugins', ':Lazy<CR>'),
        newButton('q', '󰗼 ' .. ' Quit', ':q<CR>'),
      }
      dashboard.opts.layout[3].val = 0
      dashboard.section.footer.val =
        'Now I will have less distraction.\n- Leonhard Euler'
      dashboard.section.footer.opts.hl = '@alpha.footer'
      table.insert(dashboard.config.layout, 5, {
        type = 'padding',
        val = 1,
      })
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'AlphaReady',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      require('alpha').setup(dashboard.opts)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyVimStarted',
        callback = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.buttons.val[1].val = 'Loaded '
            .. stats.count
            .. ' plugins in '
            .. ms
            .. 'ms 󰗠 '
          dashboard.section.buttons.val[1].opts.hl = '@alpha.header'
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
  {
    'luukvbaal/statuscol.nvim',
    config = function()
      local builtin = require('statuscol.builtin')
      local fi = require('statuscol.ffidef').C.fold_info
      require('statuscol').setup {
        relculright = true,
        segments = {
          {
            sign = {
              namespace = { 'gitsigns' },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
            },
            click = 'v:lua.ScSa',
            condition = {
              function(args)
                -- only show if signcolumn is enabled
                return args.sclnu
              end,
            },
          },
          {
            sign = {
              namespace = { 'diagnostic' },
              name = { 'Dap*' },
              maxwidth = 1,
              colwidth = 2,
              auto = false,
            },
            click = 'v:lua.ScSa',
            condition = {
              function(args)
                -- only show if signcolumn is enabled
                return args.sclnu
              end,
            },
          },
          { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
          {
            text = {
              -- Amazing foldcolumn
              -- https://github.com/kevinhwang91/nvim-ufo/issues/4
              function(args)
                local wp = args.wp
                local lnum = args.lnum
                local foldinfo = fi(wp, lnum)
                local foldinfo_next = fi(wp, lnum + 1)
                local level = min(foldinfo.level, 8)
                if level == 0 then
                  return '%#Normal#  '
                end
                local foldstr = ' '
                if args.virtnum ~= 0 then
                  foldstr = ' '
                elseif foldinfo.lines ~= 0 then
                  foldstr = '▹'
                elseif lnum == foldinfo.start then
                  foldstr = '◠'
                elseif
                  foldinfo.level > foldinfo_next.level
                  or (
                    foldinfo_next.start == lnum + 1
                    and foldinfo_next.level == foldinfo.level
                  )
                then
                  foldstr = '◡'
                end
                return '%#FoldCol' .. level .. '#' .. foldstr .. '%#Normal# '
              end,
            },
            click = 'v:lua.ScFa',
            condition = {
              function(args)
                return args.fold.width ~= 0
              end,
            },
          },
        },
      }
    end,
  },
  -- {
  --   '3rd/image.nvim',
  --   ft = { 'markdown', 'norg' },
  --   opts = true,
  -- },
  {
    'stevearc/oil.nvim',
    -- Don't lazy load in order to let this take over as default file explorer
    lazy = false,
    keys = {
      {
        '<leader>ft',
        function()
          require('oil').toggle_float()
        end,
      },
    },
    config = function()
      local oil = require('oil')
      oil.setup {
        float = {
          border = SETTINGS.border,
        },
        keymaps = {
          ['<Tab>'] = {
            'actions.select',
            opts = { tab = true },
            desc = 'Open the entry in new tab',
          },
          ['q'] = 'actions.close',
          ['<Esc>'] = 'actions.parent',
        },
      }
      -- Automatically open preview window
      vim.api.nvim_create_autocmd('User', {
        pattern = 'OilEnter',
        callback = vim.schedule_wrap(function(args)
          if
            vim.api.nvim_get_current_buf() == args.data.buf
            and oil.get_cursor_entry()
          then
            oil.open_preview()
          end
        end),
      })
    end,
  },
}
