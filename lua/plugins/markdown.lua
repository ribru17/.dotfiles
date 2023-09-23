return {
  {
    'ribru17/markdown-preview.nvim',
    ft = 'markdown',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  {
    'dkarter/bullets.vim',
    ft = { 'markdown', 'text' },
    cmd = { 'InsertNewBullet' },
  },
}
