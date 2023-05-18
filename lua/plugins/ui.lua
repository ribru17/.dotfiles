return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        integrations = {
          indent_blankline = {
            enabled = true,
            colored_indent_levels = true,
          },
        },
      }
      vim.cmd.colorscheme 'catppuccin'

      -- borrowed from tokyonight, might not be necessary after merging
      -- this: https://github.com/catppuccin/nvim/pull/481
      local links = {
        -- ["@lsp.type.class"] = { link = "Structure" },
        -- ["@lsp.type.decorator"] = { link = "Function" },
        -- ["@lsp.type.enum"] = { link = "Structure" },
        -- ["@lsp.type.enumMember"] = { link = "Constant" },
        -- ["@lsp.type.function"] = { link = "Function" },
        -- ["@lsp.type.interface"] = { link = "Structure" },
        -- ["@lsp.type.macro"] = { link = "Macro" },
        ['@lsp.type.method'] = { link = '@method' },       -- Function
        ['@lsp.type.namespace'] = { link = '@namespace' }, -- Structure
        ['@lsp.type.parameter'] = { link = '@parameter' }, -- Identifier
        -- ["@lsp.type.property"] = { link = "Identifier" },
        -- ["@lsp.type.struct"] = { link = "Structure" },
        -- ["@lsp.type.type"] = { link = "Type" },
        -- ["@lsp.type.typeParameter"] = { link = "TypeDef" },
        ['@lsp.type.variable'] = { fg = 'none' }, -- Identifier
        ['@lsp.type.comment'] = { fg = 'none' },  -- Comment


        ['@lsp.type.selfParameter'] = { link = '@variable.builtin' },
        -- ["@lsp.type.builtinConstant"] = { link = "@constant.builtin" },
        ['@lsp.type.builtinConstant'] = { link = '@constant.builtin' },
        ['@lsp.type.magicFunction'] = { link = '@function.builtin' },


        ['@lsp.mod.readonly'] = { link = 'Constant' },
        ['@lsp.mod.typeHint'] = { link = 'Type' },
        -- ["@lsp.mod.defaultLibrary"] = { link = "Special" },
        -- ["@lsp.mod.builtin"] = { link = "Special" },


        ['@lsp.typemod.operator.controlFlow'] = { link = '@exception' },
        ['@lsp.typemod.keyword.documentation'] = { link = 'Special' },

        ['@lsp.typemod.variable.global'] = { link = 'Constant' },
        ['@lsp.typemod.variable.static'] = { link = 'Constant' },
        -- ['@lsp.typemod.variable.defaultLibrary'] = { link = 'Special' },

        ['@lsp.typemod.function.builtin'] = { link = '@function.builtin' },
        ['@lsp.typemod.function.defaultLibrary'] = { link = '@function.builtin' },
        ['@lsp.typemod.method.defaultLibrary'] = { link = '@function.builtin' },

        ['@lsp.typemod.operator.injected'] = { link = 'Operator' },
        ['@lsp.typemod.string.injected'] = { link = 'String' },
        ['@lsp.typemod.variable.injected'] = { link = '@variable' },

        -- ['@lsp.typemod.function.readonly'] = { fg = theme.syn.fun, bold = true },
      }

      -- faster than iterating with `pairs()`
      while true do
        local k = next(links)
        if not k then break end
        vim.api.nvim_set_hl(0, k, links[k])
        links[k] = nil
      end
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
        highlights = require('catppuccin.groups.integrations.bufferline').get(),
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
        dashboard.button('t', ' ' .. ' File Tree',
          ':NvimTreeToggle <CR>'),
        dashboard.button('s', ' ' .. ' Search text',
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
