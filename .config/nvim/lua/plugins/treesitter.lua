local include_surrounding_whitespace = {
  ['@function.outer'] = true,
  ['@class.outer'] = true,
  ['@parameter.outer'] = true,
}
local SETTINGS = require('rileybruins.settings')
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
        ensure_installed = SETTINGS.ensure_installed_ts_parsers,
        sync_install = false,
        auto_install = true,

        highlight = {
          enable = true,
          disable = SETTINGS.disabled_highlighting_fts,
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

      vim.treesitter.query.add_directive(
        'ft-conceal!',
        ft_conceal,
        { force = true }
      )
    end,
  },
}
