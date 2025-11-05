local include_surrounding_whitespace = {
  ['@function.outer'] = true,
  ['@class.outer'] = true,
  ['@parameter.outer'] = true,
}
return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = { 'LazyFile' },
    opts = {
      select = {
        include_surrounding_whitespace = function(capture)
          return include_surrounding_whitespace[capture.query_string] or false
        end,
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    event = { 'LazyFile', 'VeryLazy' },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      local map = vim.keymap.set

      -- Globally map Tree-sitter text object binds
      local function textobj_map(key, query)
        local outer = '@' .. query .. '.outer'
        local inner = '@' .. query .. '.inner'
        local opts = {
          desc = 'Selection for ' .. query .. ' text objects',
          silent = true,
        }
        map({ 'x', 'o' }, 'i' .. key, function()
          require('nvim-treesitter-textobjects.select').select_textobject(inner)
        end, opts)
        map({ 'x', 'o' }, 'a' .. key, function()
          require('nvim-treesitter-textobjects.select').select_textobject(outer)
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

      map('n', '<leader>sl', function()
        require('nvim-treesitter-textobjects.swap').swap_next {
          '@swappable',
          '@parameter.inner',
        }
      end)
      map('n', '<leader>sh', function()
        require('nvim-treesitter-textobjects.swap').swap_previous {
          '@swappable',
          '@parameter.inner',
        }
      end)

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
