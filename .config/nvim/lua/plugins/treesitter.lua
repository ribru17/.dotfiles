local include_surrounding_whitespace = {
  ['@function.outer'] = true,
  ['@class.outer'] = true,
  ['@parameter.outer'] = true,
}
return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = { 'LazyFile' },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'LazyFile', 'VeryLazy' },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = require('rileybruins.settings').ensure_installed_ts_parsers,
        sync_install = false,
        auto_install = true,

        highlight = {
          enable = true,
          disable = { 'csv' }, -- get nice rainbow syntax
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        matchup = {
          enable = true, -- *very* poor performance for large files
          disable_virtual_text = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            include_surrounding_whitespace = function(ev)
              if include_surrounding_whitespace[ev.query_string] then
                return true
              end
              return false
            end,
            selection_modes = {
              ['@conditional.outer'] = 'V',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>sl'] = {
                query = { '@parameter.inner', '@swappable' },
                desc = 'Swap things that should be swappable',
              },
            },
            swap_previous = {
              ['<leader>sh'] = {
                query = { '@parameter.inner', '@swappable' },
                desc = 'Swap things that should be swappable',
              },
            },
          },
        },
      }

      local map = vim.keymap.set

      -- Globally map Tree-sitter text object binds
      local function textobj_map(key, query)
        local outer = '@' .. query .. '.outer'
        local inner = '@' .. query .. '.inner'
        local opts = {
          desc = 'Selection for ' .. query .. ' text objects',
          silent = true,
        }
        map('x', 'i' .. key, function()
          vim.cmd.TSTextobjectSelect(inner)
        end, opts)
        map('x', 'a' .. key, function()
          vim.cmd.TSTextobjectSelect(outer)
        end, opts)
        map('o', 'i' .. key, function()
          vim.cmd.TSTextobjectSelect(inner)
        end, opts)
        map('o', 'a' .. key, function()
          vim.cmd.TSTextobjectSelect(outer)
        end, opts)
      end

      textobj_map('$', 'math')
      textobj_map('m', 'math')
      textobj_map('f', 'call')
      textobj_map('F', 'function')
      textobj_map('L', 'loop')
      textobj_map('c', 'conditional')
      textobj_map('C', 'class')
      textobj_map('/', 'comment')
      textobj_map('a', 'parameter') -- also applies to arguments and array elements
      textobj_map('r', 'return')

      local non_filetype_match_injection_language_aliases = {
        ex = 'elixir',
        pl = 'perl',
        bash = 'sh', -- reversing these two from the treesitter source
        uxn = 'uxntal',
        ts = 'typescript',
      }

      -- additional language registration
      vim.treesitter.language.register('json', { 'chart' })

      -- extra icons that do not have a filetype entry in
      -- mini.icons
      local icon_overrides = {
        plantuml = '',
        ebnf = '󱘎',
        chart = '',
        nroff = '󰗚',
      }

      local get_icon = nil

      local ft_conceal = function(match, _, source, pred, metadata)
        ---@cast pred integer[]
        local capture_id = pred[2]
        if not metadata[capture_id] then
          metadata[capture_id] = {}
        end

        local node = match[pred[2]]
        local node_text = vim.treesitter.get_node_text(node, source)

        local ft = vim.filetype.match { filename = 'a.' .. node_text }
        node_text = ft
          or non_filetype_match_injection_language_aliases[node_text]
          or node_text

        if not get_icon then
          get_icon = require('mini.icons').get
        end
        metadata.conceal = icon_overrides[node_text]
          or get_icon('filetype', node_text)
          or '󰡯'
      end

      local offset_first_n = function(match, _, _, pred, metadata)
        ---@cast pred integer[]
        local capture_id = pred[2]
        if not metadata[capture_id] then
          metadata[capture_id] = {}
        end

        local range = metadata[capture_id].range
          or { match[capture_id]:range() }
        local offset = pred[3] or 0

        range[4] = range[2] + offset
        metadata[capture_id].range = range
      end

      vim.treesitter.query.add_directive(
        'offset-first-n!',
        offset_first_n,
        { force = true }
      )

      vim.treesitter.query.add_directive(
        'ft-conceal!',
        ft_conceal,
        { force = true }
      )

      -- Trim whitespace from end of the region
      -- Arguments are the captures to trim.
      vim.treesitter.query.add_directive(
        'trim-list-item!',
        ---@param match (TSNode|nil)[]
        ---@param _ string
        ---@param bufnr integer
        ---@param pred string[]
        ---@param metadata table
        function(match, _, bufnr, pred, metadata)
          for _, id in ipairs { select(2, unpack(pred)) } do
            local node = match[id]
            if not node then
              return
            end
            local start_row, start_col, end_row, end_col = node:range(false)

            while true do
              -- As we only care when end_col == 0, always inspect one line above end_row.
              local end_line =
                vim.api.nvim_buf_get_lines(bufnr, end_row - 1, end_row, true)[1]

              if end_line ~= '' then
                -- trim newline character
                end_col = #end_line
                end_row = end_row - 1
                break
              end

              end_row = end_row - 1
            end

            -- If this produces an invalid range, we just skip it.
            if
              start_row < end_row
              or (start_row == end_row and start_col <= end_col)
            then
              if not metadata[id] then
                metadata[id] = {}
              end
              metadata[id].range = { start_row, start_col, end_row, end_col }
            end
          end
        end,
        { force = true }
      )
    end,
  },
}
