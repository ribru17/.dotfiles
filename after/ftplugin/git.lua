-- use delta when showing e.g. Fugitive diffs
vim.cmd.term { 'cat', '%', '|', 'delta', '--paging=always' }
vim.cmd.startinsert()
-- not sure why this doesn't happen automatically...
vim.cmd.doautocmd('TermOpen')
