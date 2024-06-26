return {
  {
    'ribru17/markdown-preview.nvim',
    -- anchor links have an issue, see
    -- https://github.com/iamcco/markdown-preview.nvim/pull/575
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = 'markdown',
    build = 'cd app && npx --yes yarn install',
  },
  {
    'dkarter/bullets.vim',
    ft = { 'markdown', 'text', 'gitcommit' },
    cmd = { 'InsertNewBullet' },
  },
  {
    'nvim-neorg/neorg',
    ft = 'norg',
    cmd = 'Neorg',
    config = true,
  },
}
