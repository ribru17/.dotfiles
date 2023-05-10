vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.foldexpr = 'NestedMarkdownFolds()'

-- start with all folds open
vim.cmd [[silent exe "normal zR"]]

vim.keymap.set('n', 'o', '<Plug>(bullets-newline)', { remap = false })
