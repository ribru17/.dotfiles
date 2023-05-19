return {
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
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
          -- italicize parameters
          ['@parameter'] = { fg = '$red', fmt = 'italic' },
          -- make comments stand out
          ['@comment'] = { fg = '$bg_yellow', fmt = 'italic' },
          -- change bracket color so that it doesn't conflict with string color
          ['rainbowcol6'] = { fg = '$fg' },
        },
        diagnostics = {
          darker = false,
          -- for undercurl on wezterm:
          -- https://wezfurlong.org/wezterm/faq.html?highlight=undercur#how-do-i-enable-undercurl-curly-underlines
          undercurl = true,
        },
      }
      require('onedark').load()
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    event = { 'VeryLazy' },
    config = function()
      require('catppuccin').setup {
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
            ['CmpItemAbbrMatchFuzzy'] = { ctermbg = 0, fg = colors.blue, underline = true },
            -- make popup windows blend with the background better
            ['NormalFloat'] = { ctermbg = 0, bg = colors.base },
          }
        end,
      }
    end,
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
          modified_icon = '',
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(count, level)
            local icon = level:match('error') and '' or ''
            return icon .. ' ' .. count
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
        return curs[1] ..
            '/' ..
            vim.api.nvim_buf_line_count(vim.fn.winbufnr(0)) .. ',' .. curs[2]
      end

      require('lualine').setup {
        sections = {
          lualine_z = { line_total },
        },
        options = {
          disabled_filetypes = {
            'alpha',
          },
        },
        extensions = {
          'nvim-tree',
        },
      }
    end,
  },
  {
    'kyazdani42/nvim-web-devicons',
    lazy = true,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('indent_blankline').setup {
        -- reduce indentation clutter
        -- https://www.reddit.com/r/neovim/comments/yiodnb/proper_configuration_for_indentblankline/
        max_indent_increase = 1,
        char = '🭰', -- comment this out to center align indent indicator
        --> Uncomment to get colored indent lines
        -- char_highlight_list = {
        --     "IndentBlanklineIndent1",
        --     "IndentBlanklineIndent2",
        --     "IndentBlanklineIndent3",
        --     "IndentBlanklineIndent4",
        --     "IndentBlanklineIndent5",
        --     "IndentBlanklineIndent6",
        -- },
      }
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'VeryLazy' },
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- next/prev git changes
          map({ 'n', 'x' }, '<leader>gj', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          map({ 'n', 'x' }, '<leader>gk', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          -- git preview
          map('n', '<leader>gp', gs.preview_hunk)
          -- git blame
          map('n', '<leader>gb', function() gs.blame_line { full = true } end)
          -- undo git change
          map('n', '<leader>gu', gs.reset_hunk)
          -- undo all git changes
          map('n', '<leader>gr', gs.reset_buffer)
        end,
        sign_priority = 0,
      }
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    lazy = true,
    keys = {
      { '<leader>ff' },
      { '<leader>fs' },
      { '<leader>fg' },
      { '<leader>fw' },
      { '<leader>fc' },
    },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local actions = require('telescope.actions')

      -- open selected buffers in new tabs
      local function multi_tab(prompt_bufnr)
        local state = require 'telescope.actions.state'
        local picker = state.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()
        local str = ''
        if #multi > 0 then
          for _, j in pairs(multi) do
            str = str .. 'tabe ' .. j.filename .. ' | '
          end
          -- To avoid populating qf or doing ":edit! file", close the prompt first
          actions.close(prompt_bufnr)
          vim.api.nvim_command(str)
        else
          -- only open selected buffer in new tab if selection is empty
          require('telescope.actions').select_tab(prompt_bufnr)
        end
      end

      local function close_with_action(prompt_bufnr)
        require('telescope.actions').close(prompt_bufnr)
        vim.cmd [[NvimTreeFindFileToggle]]
      end

      local putils = require('telescope.previewers.utils')
      require('telescope').setup {
        defaults = {
          preview = {
            filetype_hook = function(_, bufnr, opts)
              -- don't display jank pdf previews
              if opts.ft == 'pdf' then
                putils.set_preview_message(bufnr, opts.winid,
                  'Not displaying ' .. opts.ft)
                return false
              end
              return true
            end,
          },
          layout_config = {
            horizontal = {
              preview_cutoff = 0,
            },
          },
          prompt_prefix = '🔎 ',
          initial_mode = 'normal',
          mappings = {
            n = {
              ['<Tab>'] = multi_tab, -- <Tab> to open as tab
              ['<leader>t'] = close_with_action,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
              ['t'] = actions.toggle_selection + actions.move_selection_previous,
              ['q'] = actions.close,
            },
            i = {
              ['<Tab>'] = multi_tab, -- <Tab> to open as tab
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-t>'] = actions.toggle_selection + actions.move_selection_previous,
            },
          },
        },
      }

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', function()
        -- ignore opened buffers if not in dashboard or directory
        if vim.fn.isdirectory(vim.fn.expand('%')) == 1 or vim.bo.filetype == 'alpha' then
          builtin.find_files()
        else
          local function literalize(str)
            return str:gsub('[%(%)%.%%%+%-%*%?%[%]%^%$]',
              function(c) return '%' .. c end)
          end

          local function get_open_buffers()
            local buffers = {}
            local len = 0
            local vim_fn = vim.fn
            local buflisted = vim_fn.buflisted

            for buffer = 1, vim_fn.bufnr('$') do
              if buflisted(buffer) == 1 then
                len = len + 1
                -- get relative name of buffer without leading slash
                buffers[len] = string.gsub(vim.api.nvim_buf_get_name(buffer),
                  literalize(vim.loop.cwd()), ''):sub(2)
              end
            end

            return buffers
          end

          builtin.find_files {
            file_ignore_patterns = get_open_buffers(),
          }
        end
      end, {})
      vim.keymap.set('n', '<leader>fg',
        function()
          builtin.grep_string { search = vim.fn.input('Grep > ') }
        end, {})
      vim.keymap.set('n', '<leader>fs', function()
        builtin.live_grep { initial_mode = 'insert' }
      end, {})
      vim.keymap.set('n', '<leader>fw', builtin.git_files, {})
      vim.keymap.set('n', '<leader>fc',
        function() builtin.colorscheme { enable_preview = true } end, {})
    end,
  },
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    opts = function()
      local dashboard = require('alpha.themes.dashboard')
      local logo = [[
██████╗ ██████╗    ███╗   ██╗██╗   ██╗██╗███╗   ███╗
██╔══██╗██╔══██╗   ████╗  ██║██║   ██║██║████╗ ████║
██████╔╝██████╔╝   ██╔██╗ ██║██║   ██║██║██╔████╔██║
██╔══██╗██╔══██╗   ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║  ██║██████╔╝██╗██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]

      dashboard.section.header.val = vim.split(logo, '\n')
      dashboard.section.buttons.val = {
        {
          type = 'text',
          val = ' ',
          opts = {
            position = 'center',
          },
        },
        { type = 'padding', val = 2 },
        dashboard.button('f', ' ' .. ' Open file',
          ":lua require('telescope.builtin').find_files()<CR>"),
        dashboard.button('r', ' ' .. ' Open recent',
          ":lua require('telescope.builtin').oldfiles()<CR>"),
        dashboard.button('t', ' ' .. ' File tree',
          ':NvimTreeToggle <CR>'),
        dashboard.button('s', ' ' .. ' Search for text',
          ":lua require('telescope.builtin').live_grep({initial_mode = 'insert'})<CR>"),
        dashboard.button('l', ' ' .. " LSP's", ':Mason<CR>'),
        dashboard.button('p', ' ' .. ' Plugins', ':Lazy<CR>'),
        dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
      }
      dashboard.opts.layout[1].val = 4
      dashboard.opts.layout[3].val = 0
      dashboard.section.footer.val =
      'Now I will have less distraction.\n- Leonhard Euler'
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
          dashboard.section.buttons.val[1].val = '⚡ Loaded ' ..
              stats.count .. ' plugins in ' .. ms .. 'ms'
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    keys = {
      { '<leader>t', '<Cmd>NvimTreeFindFileToggle<CR>' },
    },
    cmd = { 'NvimTreeFindFileToggle', 'NvimTreeToggle' },
    config = function()
      local HEIGHT_RATIO = 0.75
      local WIDTH_RATIO = 0.5

      local function on_attach(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return {
            desc = 'nvim-tree: ' .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        -- BEGIN_DEFAULT_ON_ATTACH
        vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
        vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,
          opts('Open: In Place'))
        vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
        vim.keymap.set('n', '<C-r>', api.fs.rename_sub,
          opts('Rename: Omit Filename'))
        vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
        vim.keymap.set('n', '<C-v>', api.node.open.vertical,
          opts('Open: Vertical Split'))
        vim.keymap.set('n', '<C-x>', api.node.open.horizontal,
          opts('Open: Horizontal Split'))
        vim.keymap.set('n', '<BS>', api.node.navigate.parent_close,
          opts('Close Directory'))
        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
        vim.keymap.set('n', '>', api.node.navigate.sibling.next,
          opts('Next Sibling'))
        vim.keymap.set('n', '<', api.node.navigate.sibling.prev,
          opts('Previous Sibling'))
        vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))
        vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
        vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
        vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
        vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter,
          opts('Toggle No Buffer'))
        vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
        vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter,
          opts('Toggle Git Clean'))
        vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
        vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
        vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
        vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
        vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
        vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
        vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next,
          opts('Next Diagnostic'))
        vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev,
          opts('Prev Diagnostic'))
        vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
        vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
        vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
        vim.keymap.set('n', 'gy', api.fs.copy.absolute_path,
          opts('Copy Absolute Path'))
        vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter,
          opts('Toggle Dotfiles'))
        vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter,
          opts('Toggle Git Ignore'))
        vim.keymap.set('n', 'J', api.node.navigate.sibling.last,
          opts('Last Sibling'))
        vim.keymap.set('n', 'K', api.node.navigate.sibling.first,
          opts('First Sibling'))
        vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
        vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'O', api.node.open.no_window_picker,
          opts('Open: No Window Picker'))
        vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
        vim.keymap.set('n', 'P', api.node.navigate.parent,
          opts('Parent Directory'))
        vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
        vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
        vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
        vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
        vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
        vim.keymap.set('n', 'U', api.tree.toggle_custom_filter,
          opts('Toggle Hidden'))
        vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
        vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
        vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
        vim.keymap.set('n', 'Y', api.fs.copy.relative_path,
          opts('Copy Relative Path'))
        vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node,
          opts('CD'))
        -- END_DEFAULT_ON_ATTACH

        vim.keymap.set('n', '.', api.tree.toggle_hidden_filter,
          opts('Toggle Dotfiles'))
        vim.keymap.set('n', 'n', api.fs.create, opts('Create'))
        vim.keymap.set('n', 'r', api.fs.rename_sub, opts('Rename: Omit Filename'))
        vim.keymap.set('n', 'a', api.tree.change_root_to_node, opts('CD'))
        vim.keymap.set('n', '<C-r>', api.tree.reload, opts('Refresh'))
        vim.keymap.set('n', '<Tab>', api.node.open.tab, opts('Open: New Tab'))
        vim.keymap.set('n', 'd', api.fs.trash, opts('Trash'))
        vim.keymap.set('n', 'D',
          '<Cmd>lua require("nvim-tree.api").fs.create()<CR>/<Left>',
          opts('Create Directory'))
        vim.keymap.set('n', '<Esc>', api.tree.close, opts('Close'))
        vim.keymap.set('n', 'z', api.node.navigate.parent_close,
          opts('Close Directory'))
      end

      require('nvim-tree').setup {
        on_attach = on_attach,
        hijack_cursor = true,
        view = {
          float = {
            enable = true,
            open_win_config = function()
              -- center the window
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2) -
                  vim.opt.cmdheight:get()

              return {
                relative = 'editor',
                border = 'rounded',
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
        },
        renderer = {
          -- add a '/' at the end of a folder
          add_trailing = true,
          icons = {
            show = {
              -- remove annoying icons in front of file names
              modified = false,
              git = false,
            },
          },
          -- don't highlight special files, only opened ones
          highlight_opened_files = 'name',
          special_files = {},
        },
        -- synchronize the file tree across tabs (emulate VS Code style)
        -- not really necessary since we are using the float style view but
        -- going to keep it in just in case we want to switch back to the
        -- classic view
        tab = {
          sync = {
            open = true,
            close = true,
          },
        },
      }
    end,
  },
  {
    'Bekaboo/deadcolumn.nvim',
    event = { 'VeryLazy' },
    opts = {
      blending = {
        threshold = 0.75,
      },
      warning = {
        colorcode = '#ED8796',
      },
    },
  },
}
