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
            keymaps = {
              ['a/'] = '@comment.outer',
              ['i/'] = '@comment.outer',
              ['ac'] = '@conditional.outer',
              ['ic'] = '@conditional.inner',
              ['af'] = '@call.outer',
              ['if'] = '@call.inner',
              ['aF'] = '@function.outer',
              ['iF'] = '@function.inner',
              ['aL'] = '@loop.outer',
              ['iL'] = '@loop.inner',
            },
            selection_modes = {
              ['@comment.outer'] = 'V',
              ['@conditional.outer'] = 'V',
              ['@conditional.inner'] = 'V',
            },
          },
          -- TODO: Add generalized `@swappable` nodes
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

      local map = vim.keymap.set
      local math_obj_opts = {
        desc = 'Custom text object to delete inside "$" delimiters',
      }
      map('x', 'i$', function()
        require('nvim-treesitter.textobjects.select').select_textobject(
          '@math.inner',
          'textobjects',
          'v'
        )
      end, math_obj_opts)
      map('x', 'a$', function()
        require('nvim-treesitter.textobjects.select').select_textobject(
          '@math.outer',
          'textobjects',
          'v'
        )
      end, math_obj_opts)
      map('o', 'i$', function()
        require('nvim-treesitter.textobjects.select').select_textobject(
          '@math.inner',
          'textobjects',
          'o'
        )
      end, math_obj_opts)
      map('o', 'a$', function()
        require('nvim-treesitter.textobjects.select').select_textobject(
          '@math.outer',
          'textobjects',
          'o'
        )
      end, math_obj_opts)
      map('x', 'im', function()
        require('nvim-treesitter.textobjects.select').select_textobject(
          '@math.inner',
          'textobjects',
          'v'
        )
      end, math_obj_opts)
      map('x', 'am', function()
        require('nvim-treesitter.textobjects.select').select_textobject(
          '@math.outer',
          'textobjects',
          'v'
        )
      end, math_obj_opts)
      map('o', 'im', function()
        require('nvim-treesitter.textobjects.select').select_textobject(
          '@math.inner',
          'textobjects',
          'o'
        )
      end, math_obj_opts)
      map('o', 'am', function()
        require('nvim-treesitter.textobjects.select').select_textobject(
          '@math.outer',
          'textobjects',
          'o'
        )
      end, math_obj_opts)
    end,
  },
}
