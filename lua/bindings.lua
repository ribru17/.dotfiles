--> MISCELLANEOUS KEYMAPS <--

-- VSCode style block indentation
vim.keymap.set('x', '<Tab>', '>gv', { remap = false })
vim.keymap.set('x', '<S-Tab>', '<gv', { remap = false })
vim.keymap.set('n', '<Tab>', '>>', { remap = false })
vim.keymap.set('n', '<S-Tab>', '<<', { remap = false })

-- move selected code blocks smartly with
-- indenting for if statements and such
vim.keymap.set('x', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('x', 'K', ":m '<-2<CR>gv=gv")

-- easily move cursor selection backwards
vim.keymap.set('x', '<C-h>', 'oho', { remap = false })
vim.keymap.set('x', '<C-l>', 'olo', { remap = false })
vim.keymap.set('x', '<C-k>', 'oko', { remap = false })
vim.keymap.set('x', '<C-j>', 'ojo', { remap = false })

-- keep cursor in place
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- surround visual selection
vim.keymap.set('x', 's', 'S', { remap = true })

-- clear search highlighting
vim.keymap.set('n', '<Esc>', ':noh<CR>')

-- don't enter ex mode(?) by accident
vim.keymap.set('n', 'Q', '<nop>')

-- replace instances of hovered word
vim.keymap.set('n', '<leader>h',
  ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gIc<Left><Left><Left><Left>')
vim.keymap.set('n', '<leader>H',
  ':%S/<C-r><C-w>/<C-r><C-w>/gcw<Left><Left><Left><Left>')

-- crude search & replace visual selection (breaks on multiple lines, special chars)
vim.keymap.set('x', '<leader>h', '"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>',
  { remap = false })

-- change current HTML-style tags
vim.keymap.set('n', '<leader>cht', 'cst', { remap = true })
-- delete current HTML-style tags
vim.keymap.set('n', '<leader>dht', 'dst', { remap = true })
-- delete surrounding delimiters
vim.keymap.set('n', '<leader>dq', 'dsq', { remap = true })
vim.keymap.set('n', '<leader>dp', 'ds(', { remap = true })
vim.keymap.set('n', '<leader>db', 'dsb', { remap = true })
vim.keymap.set('n', '<leader>dd', 'dsd', { remap = true })

-- cycle through tabs (reversing order for more intuitive UX)
vim.keymap.set('n', '<C-n>', '<Cmd>BufferLineCyclePrev<CR>', {})
vim.keymap.set('n', '<C-p>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<C-l>', '<Cmd>tabmove +1<CR>', {})
vim.keymap.set('n', '<C-h>', '<Cmd>tabmove -1<CR>', {})
vim.keymap.set('n', '<C-t>', '<cmd>tabnew<cr>', {})

-- copy/cut to clipboard (Linux)
vim.keymap.set('v', '<C-y>', '"+y', { remap = false })
vim.keymap.set('v', '<C-x>', '"+x', { remap = false })

-- navigation while typing
vim.keymap.set({ 'i', 'c' }, '<C-k>', '<Up>', { remap = false })
vim.keymap.set({ 'i', 'c' }, '<C-h>', '<Left>', { remap = false })
vim.keymap.set({ 'i', 'c' }, '<C-j>', '<Down>', { remap = false })
vim.keymap.set({ 'i', 'c' }, '<C-l>', '<Right>', { remap = false })
vim.keymap.set({ 'i', 'c' }, '<C-w>', '<C-Right>', { remap = false })
vim.keymap.set({ 'i', 'c' }, '<C-b>', '<C-Left>', { remap = false })

-- quicker than hitting esc?
vim.keymap.set('i', '<M-i>', '<Esc>', { remap = false })

-- delete word in insert mode
vim.keymap.set('i', '<M-BS>', '<C-w>', { remap = false })

-- Make comment work on terminals where C-/ is literally C-/
vim.keymap.set('n', '<C-/>', '<C-_>', { remap = true })
vim.keymap.set('v', '<C-/>', '<C-_>', { remap = true })
vim.keymap.set('i', '<C-/>', '<C-_>', { remap = true })

-- easier keybind of bullet formatting
vim.keymap.set('i', '<C-f>', '<C-t>', { remap = true })

-- toggle current fold
vim.keymap.set('n', '<leader>z', 'za', { remap = true })
vim.keymap.set('n', 'zz', 'za', { remap = true })
-- fold all except current
vim.keymap.set('n', 'zf', 'zMzv', { remap = true })
-- open all folds
vim.keymap.set('n', 'zo', 'zR', { remap = true })
-- fold selected lines
vim.keymap.set('x', '<leader>z', 'zf', { remap = true })
vim.keymap.set('x', 'zz', 'zf', { remap = true })

-- cursor-in-place copy/paste
vim.keymap.set('n', 'P', 'P`[', { remap = false })
vim.keymap.set('x', 'y', 'ygv<Esc>', { remap = false })

--> END OF MISCELLANEOUS KEYMAPS <--

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--> MISCELLANEOUS USER COMMANDS <--

-- write without formatting
vim.api.nvim_create_user_command('W', 'noa w', {})
vim.api.nvim_create_user_command('Wq', 'noa w | q', {})
vim.api.nvim_create_user_command('Wa', 'noa wa', {})
vim.api.nvim_create_user_command('Wqa', 'noa wa | qa', {})
vim.api.nvim_create_user_command('Wn', 'noa wn', {})
vim.api.nvim_create_user_command('WN', 'noa wN', {})
vim.api.nvim_create_user_command('Wp', 'noa wp', {})

--> END OF MISCELLANEOUS USER COMMANDS <--
