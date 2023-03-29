return {
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    'iurimateus/luasnip-latex-snippets.nvim',
    ft = 'markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('luasnip-latex-snippets').setup({ use_treesitter = true })
    end
  },
}
