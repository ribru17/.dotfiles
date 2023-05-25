return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require 'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all" (the first five parsers should always be installed)
        ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'javascript',
          'typescript', 'rust', 'tsx', 'markdown', 'markdown_inline', 'latex',
          'mermaid', 'comment', },

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
          disable = { 'html' },
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        rainbow = {
          enable = true,
          strategy = {
            -- disable this extension for all other filetypes
            function()
              return nil
            end,
            -- only enable it for files that would actually need it
            commonlisp = require('ts-rainbow').strategy['global'],
          },
        },
      }
    end,
  },
}
