return {
  {
    'tpope/vim-fugitive',
    cmd = 'Git'
  },
  {
    'tpope/vim-abolish',
    cmd = 'S'
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
        aliases = {
          ["d"] = { "{", "[", "(", "<", '"', "'", "`" }, -- any delimiter
          ["b"] = { "{", "[", "(", "<" },                -- bracket
          ["p"] = { "(" },
        },
        move_cursor = false,
      })
    end
  },
  {
    'numToStr/Comment.nvim',
    keys = {
      { mode = "n", "<C-_>", },
      { mode = "x", "<C-_>", },
      "gc",
      "gb",
    },
    config = function()
      require('Comment').setup({
        toggler = {
          line = '<C-_>',
        },
        opleader = {
          line = '<C-_>'
        },
      })
    end
  },
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'xml', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx',
      'jsx', 'rescript', 'php', 'markdown', 'glimmer', 'handlebars', 'hbs'
    }
  },
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime'
  }
}
