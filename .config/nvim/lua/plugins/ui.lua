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
          ['@comment.syntax'] = { link = 'Comment' },
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
    event = { 'VeryLazy' },
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
    'nvim-tree/nvim-web-devicons',
    config = function()
      local devicons = require('nvim-web-devicons')
      local icons = devicons.get_icons()
      devicons.setup {
        override_by_extension = {
          ['scm'] = icons['query'],
          ['ss'] = icons['scm'],
        },
      }
    end,
    lazy = true,
  },
  {
    'git@github.com:ribru17/telescope.nvim.git',
    keys = {
      { '<leader>ff' },
      { '<leader>fs' },
      { '<leader>fg' },
      { '<leader>fw' },
      { '<leader>fc' },
    },
    cmd = 'Telescope',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
    },
    config = function()
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      local previewers = require('telescope.previewers')
      local builtin = require('telescope.builtin')

      local get_git_delta_opts = function()
        return {
          'git',
          '-c',
          'core.pager=delta',
          '-c',
          'delta.side-by-side=false',
          '-c',
          'delta.line-numbers=true',
          '-c',
          'delta.hunk-header-style=omit',
        }
      end

      local delta_status = previewers.new_termopen_previewer {
        get_command = function(entry)
          local value = SETTINGS.in_dotfiles
              and vim.env.HOME .. '/' .. entry.value
            or entry.value
          if entry.status == '??' or entry.status == 'A ' then
            -- show a diff against the null file, since the current file is
            -- either untracked or was just added
            return vim.list_extend(get_git_delta_opts(), {
              'diff',
              '--no-index',
              '--',
              '/dev/null',
              value,
            })
          end
          -- show the regular diff of the file against HEAD
          return vim.list_extend(get_git_delta_opts(), {
            'diff',
            'HEAD',
            '--',
            value,
          })
        end,
      }

      local delta_b = previewers.new_termopen_previewer {
        get_command = function(entry)
          return vim.list_extend(get_git_delta_opts(), {
            'diff',
            entry.value .. '^!',
            '--',
            entry.current_file,
            -- show dotfiles diffs pre- and post-migration to bare repo
            SETTINGS.in_dotfiles
                and (entry.current_file:gsub('.config/nvim/', ''))
              or nil,
          })
        end,
      }

      local delta = previewers.new_termopen_previewer {
        get_command = function(entry)
          return vim.list_extend(get_git_delta_opts(), {
            'diff',
            entry.value .. '^!',
          })
        end,
      }

      local function delta_git_commits(opts)
        opts = opts or {}
        opts.previewer = {
          delta,
          previewers.git_commit_message.new(opts),
          previewers.git_commit_diff_as_was.new(opts),
        }
        opts = vim.tbl_extend('keep', opts, SETTINGS.telescope_centered_picker)
        builtin.git_commits(opts)
      end

      local function delta_git_bcommits(opts)
        opts = opts or {}
        opts.previewer = {
          delta_b,
          previewers.git_commit_message.new(opts),
          previewers.git_commit_diff_as_was.new(opts),
        }
        opts = vim.tbl_extend('keep', opts, SETTINGS.telescope_centered_picker)
        builtin.git_bcommits(opts)
      end

      local function delta_git_status(opts)
        opts = opts or {}
        opts.previewer = {
          delta_status,
          previewers.git_commit_message.new(opts),
          previewers.git_commit_diff_as_was.new(opts),
        }
        opts = vim.tbl_extend('keep', opts, SETTINGS.telescope_centered_picker)
        opts.expand_dir = not SETTINGS.in_dotfiles
        builtin.git_status(opts)
      end

      builtin.delta_git_commits = delta_git_commits
      builtin.delta_git_bcommits = delta_git_bcommits
      builtin.delta_git_status = delta_git_status

      -- open selected buffers in new tabs
      local function multi_tab(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi_selection = picker:get_multi_selection()

        if #multi_selection > 1 then
          require('telescope.pickers').on_close_prompt(prompt_bufnr)
          pcall(vim.api.nvim_set_current_win, picker.original_win_id)

          for _, entry in ipairs(multi_selection) do
            local filename, row, col

            if entry.path or entry.filename then
              filename = entry.path or entry.filename

              row = entry.row or entry.lnum
              col = vim.F.if_nil(entry.col, 1)
            elseif not entry.bufnr then
              local value = entry.value
              if not value then
                return
              end

              if type(value) == 'table' then
                value = entry.display
              end

              local sections = vim.split(value, ':')

              filename = sections[1]
              row = tonumber(sections[2])
              col = tonumber(sections[3])
            end

            local entry_bufnr = entry.bufnr

            if entry_bufnr then
              if
                not vim.api.nvim_buf_get_option_value(entry_bufnr, 'buflisted')
              then
                vim.api.nvim_buf_set_option_value(
                  entry_bufnr,
                  'buflisted',
                  true
                )
              end
              pcall(vim.cmd.sbuffer, {
                filename,
                mods = {
                  tab = 1,
                },
              })
            else
              filename = require('plenary.path')
                :new(vim.fn.fnameescape(filename))
                :normalize(vim.uv.cwd())
              pcall(vim.cmd.tabedit, filename)
            end

            if row and col then
              pcall(vim.api.nvim_win_set_cursor, 0, { row, col - 1 })
            end
          end
        else
          actions.select_tab(prompt_bufnr)
        end
      end

      local putils = require('telescope.previewers.utils')
      local telescope = require('telescope')

      telescope.setup {
        pickers = {
          find_files = {
            find_command = { 'rg', '--files', '--sortr=modified' },
          },
        },
        defaults = {
          set_env = {
            LESS = '',
            DELTA_PAGER = 'less',
          },
          preview = {
            filetype_hook = function(filepath, bufnr, opts)
              -- don't display jank pdf previews
              if opts.ft == 'pdf' then
                putils.set_preview_message(
                  bufnr,
                  opts.winid,
                  'Not displaying ' .. opts.ft
                )
                return false
              end
              -- don't syntax highlight minified js
              if
                filepath:find('[-.]min%.js$') or filepath:find('app/out.*js$')
              then
                vim.schedule(function()
                  vim.treesitter.stop(bufnr)
                end)
              end
              return true
            end,
          },
          borderchars = SETTINGS.telescope_border_chars,
          path_display = { 'filename_first' },
          layout_config = {
            horizontal = {
              preview_cutoff = 0,
              preview_width = 0.5,
            },
          },
          prompt_prefix = '  ',
          initial_mode = 'normal',
          mappings = {
            n = {
              ['<Tab>'] = multi_tab, -- <Tab> to open as tab
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
              ['<Space>'] = {
                actions.toggle_selection + actions.move_selection_previous,
                type = 'action',
                opts = { nowait = true, silent = true, noremap = true },
              },
              ['q'] = {
                actions.close,
                type = 'action',
                opts = { nowait = true, silent = true, noremap = true },
              },
              ['<C-l>'] = actions.preview_scrolling_right,
              ['<C-h>'] = actions.preview_scrolling_left,
            },
            i = {
              ['<Tab>'] = multi_tab, -- <Tab> to open as tab
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-Space>'] = {
                actions.toggle_selection + actions.move_selection_previous,
                type = 'action',
                opts = { nowait = true, silent = true, noremap = true },
              },
              ['<C-l>'] = false, -- override telescope's default
              ['<M-BS>'] = { '<C-s-w>', type = 'command' },
            },
          },
        },
      }

      vim.keymap.set('n', '<leader>ff', function()
        -- ignore opened buffers if not in dashboard or directory
        if
          vim.fn.isdirectory(vim.fn.expand('%')) == 1
          or vim.bo.filetype == 'alpha'
        then
          builtin.find_files()
        else
          local function literalize(str)
            return str:gsub('[%(%)%.%%%+%-%*%?%[%]%^%$]', function(c)
              return '%' .. c
            end)
          end

          local function get_open_buffers()
            local buffers = {}
            local len = 0
            local vim_fn = vim.fn
            local win_findbuf = vim_fn.win_findbuf

            for buffer = 1, vim_fn.bufnr('$') do
              if #win_findbuf(buffer) ~= 0 then
                len = len + 1
                -- get relative name of buffer without leading slash
                buffers[len] = '^'
                  .. literalize(
                    string
                      .gsub(
                        vim.api.nvim_buf_get_name(buffer),
                        literalize(vim.uv.cwd()),
                        ''
                      )
                      :sub(2)
                  )
                  .. '$'
              end
            end

            return buffers
          end

          builtin.find_files {
            file_ignore_patterns = get_open_buffers(),
          }
        end
      end, { desc = 'Search for files (ignoring already opened ones)' })
      vim.keymap.set('n', '<leader>fg', function()
        builtin.grep_string { search = vim.fn.input('Grep > ') }
      end, { desc = 'Search content of files' })
      vim.keymap.set('n', '<leader>fs', function()
        builtin.live_grep { initial_mode = 'insert' }
      end, { desc = 'Live-search content of files' })
      vim.keymap.set(
        'n',
        '<leader>fw',
        builtin.git_files,
        { desc = 'Search files in the Git working tree' }
      )
      vim.keymap.set('n', '<leader>fc', function()
        local load_scheme = require('lazy.core.loader').colorscheme
        for _, value in pairs(SETTINGS.lazy_loaded_colorschemes) do
          load_scheme(value)
        end
        vim.keymap.set('n', '<leader>fc', function()
          builtin.colorscheme { enable_preview = true }
        end)
        builtin.colorscheme { enable_preview = true }
      end, { desc = 'Preview color schemes' })

      telescope.load_extension('fzf')
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
        newButton(
          'f',
          ' ' .. ' Open file',
          ":lua require('telescope.builtin').find_files()<CR>"
        ),
        newButton(
          'r',
          ' ' .. ' Open recent',
          ":lua require('telescope.builtin').oldfiles()<CR>"
        ),
        newButton(
          't',
          ' ' .. ' File tree',
          ':lua require("mini.files").open(vim.api.nvim_buf_get_name(0), false)<CR>'
        ),
        newButton(
          's',
          ' ' .. ' Search for text',
          ":lua require('telescope.builtin').live_grep({initial_mode = 'insert'})<CR>"
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
    'Bekaboo/deadcolumn.nvim',
    event = { 'VeryLazy' },
    config = function()
      require('deadcolumn').setup {
        blending = {
          threshold = 0.75,
        },
        warning = {
          alpha = 0.2,
        },
      }
    end,
  },
  {
    'luukvbaal/statuscol.nvim',
    event = { 'LazyFile' },
    config = function()
      local builtin = require('statuscol.builtin')
      local c = require('statuscol.ffidef').C
      require('statuscol').setup {
        relculright = true,
        segments = {
          {
            sign = {
              namespace = { 'gitsigns' },
              name = { '.*' },
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
              maxwidth = 2,
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
          { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
          {
            text = {
              -- Amazing foldcolumn
              -- https://github.com/kevinhwang91/nvim-ufo/issues/4
              function(args)
                local foldinfo = c.fold_info(args.wp, args.lnum)
                local foldinfo_next = c.fold_info(args.wp, args.lnum + 1)
                local level = foldinfo.level
                local foldstr = ' '
                local hl = '%#FoldCol' .. level .. '#'
                if level == 0 then
                  hl = '%#Normal#'
                  foldstr = ' '
                  return hl .. foldstr .. '%#Normal# '
                end
                if level > 8 then
                  hl = '%#FoldCol8#'
                end
                if foldinfo.lines ~= 0 then
                  foldstr = '▹'
                elseif args.lnum == foldinfo.start then
                  foldstr = '◠'
                elseif
                  foldinfo.level > foldinfo_next.level
                  or (
                    foldinfo_next.start == args.lnum + 1
                    and foldinfo_next.level == foldinfo.level
                  )
                then
                  foldstr = '◡'
                end
                return hl .. foldstr .. '%#Normal# '
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
    'Bekaboo/dropbar.nvim',
  },
  {
    'echasnovski/mini.files',
    keys = { '<leader>ft' },
    config = function()
      local MiniFiles = require('mini.files')
      MiniFiles.setup {
        windows = {
          preview = true,
          width_preview = 50,
          width_focus = 25,
        },
        mappings = {
          go_in_plus = '<CR>',
        },
      }
      vim.keymap.set('n', '<leader>ft', function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      end)

      local show_dotfiles = true
      local MiniFiles = require('mini.files')
      local filter_show = function(_fs_entry)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, '.')
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        MiniFiles.refresh { content = { filter = new_filter } }
      end

      local tab_open = function(buf_id, lhs)
        local rhs = function()
          local new_target_window
          local cur_target_window = MiniFiles.get_target_window()
          if cur_target_window ~= nil then
            vim.api.nvim_win_call(cur_target_window, function()
              vim.cmd.tabe()
              new_target_window = vim.api.nvim_get_current_win()
            end)

            MiniFiles.set_target_window(new_target_window)
            MiniFiles.go_in()
          end

          MiniFiles.close()
          vim.cmd.tabprev()
          MiniFiles.open(MiniFiles.get_latest_path())
        end

        local desc = 'Open in new tab'
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesWindowOpen',
        callback = function(args)
          local win_id = args.data.win_id
          vim.api.nvim_win_set_config(win_id, { border = SETTINGS.border })
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id

          vim.keymap.set(
            'n',
            'g.',
            toggle_dotfiles,
            { buffer = buf_id, desc = 'Toggle hidden files' }
          )

          vim.keymap.set(
            'n',
            '<Esc>',
            MiniFiles.close,
            { buffer = buf_id, desc = 'Close the file explorer' }
          )

          tab_open(buf_id, '<Tab>')
        end,
      })
    end,
  },
}
