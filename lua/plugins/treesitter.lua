return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        -- A list of parser names, or "all" (the first five parsers should always be installed)
        ensure_installed = require('rileybruins.settings').ensure_installed_ts_parsers,

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        highlight = {
          -- `false` will disable the whole extension
          enable = true,
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        -- HTML-style tag completion
        autotag = {
          enable = true,
          -- disable auto-close because we manually implement this in luasnip
          -- https://github.com/windwp/nvim-ts-autotag/pull/105#discussion_r1179164951
          enable_close = 'false',
        },
        indent = {
          enable = true,
        },
        matchup = {
          enable = true,
          disable_virtual_text = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            include_surrounding_whitespace = true,
            selection_modes = {
              ['@comment.outer'] = 'V',
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

      local non_filetype_match_injection_language_aliases = {
        ex = 'elixir',
        pl = 'perl',
        bash = 'sh', -- reversing these two from the treesitter source
        uxn = 'uxntal',
        ts = 'typescript',
      }

      -- extra fallbacks for icons that do not have a filetype entry in nvim-
      -- devicons
      local icon_fallbacks = {
        mermaid = '󰈺',
        plantuml = '',
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
          get_icon = require('nvim-web-devicons').get_icon_by_filetype
        end
        metadata.conceal = get_icon(node_text)
          or icon_fallbacks[node_text]
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

      -- predicates for formatting of query files
      vim.treesitter.query.add_predicate(
        'has-type?',
        function(match, _, _, pred)
          local node = match[pred[2]]
          if not node then
            return true
          end

          local types = { unpack(pred, 3) }
          local type = node:type()
          for _, value in pairs(types) do
            if value == type then
              return true
            end
          end
          return false
        end,
        true
      )
      vim.treesitter.query.add_predicate(
        'is-start-of-line?',
        function(match, _, _, pred)
          local node = match[pred[2]]
          if not node then
            return true
          end
          local start_row, start_col = node:start()
          return vim.fn.indent(start_row + 1) == start_col
        end
      )

      vim.treesitter.query.add_directive(
        'offset-first-n!',
        offset_first_n,
        true
      )

      vim.treesitter.query.add_directive('ft-conceal!', ft_conceal, true)

      -- Trim whitespace from end of the region
      -- Arguments are the captures to trim.
      vim.treesitter.query.add_directive(
        'trim-charwise!',
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
            local start_row, start_col, end_row, end_col = node:range()

            -- Don't trim if region ends in middle of a line
            if end_col ~= 0 then
              return
            end

            while true do
              -- As we only care when end_col == 0, always inspect one line above end_row.
              local end_line =
                vim.api.nvim_buf_get_lines(bufnr, end_row - 1, end_row, true)[1]

              if end_line ~= '' then
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
        true
      )

      local map = vim.keymap.set
      local select_ob =
        require('nvim-treesitter.textobjects.select').select_textobject

      local function textobj_map(key, query)
        local outer = '@' .. query .. '.outer'
        local inner = '@' .. query .. '.inner'
        local opts = {
          desc = 'Selection for ' .. query .. ' text objects',
          silent = true,
        }
        map('x', 'i' .. key, function()
          select_ob(inner, 'textobjects', 'v')
        end, opts)
        map('x', 'a' .. key, function()
          select_ob(outer, 'textobjects', 'v')
        end, opts)
        map('o', 'i' .. key, function()
          select_ob(inner, 'textobjects', 'o')
        end, opts)
        map('o', 'a' .. key, function()
          select_ob(outer, 'textobjects', 'o')
        end, opts)
      end

      textobj_map('$', 'math')
      textobj_map('m', 'math')
      textobj_map('f', 'call')
      textobj_map('F', 'function')
      textobj_map('L', 'loop')
      textobj_map('c', 'conditional')
      textobj_map('/', 'comment')
    end,
  },
}
