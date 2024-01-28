return {
  {
    'ribru17/markdown-preview.nvim',
    -- anchor links have an issue, see
    -- https://github.com/iamcco/markdown-preview.nvim/pull/575
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
