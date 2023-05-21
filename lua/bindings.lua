--> MISCELLANEOUS KEYMAPS <--

-- VSCode style block indentation
vim.keymap.set('x', '<Tab>', '>gv', { remap = false })
vim.keymap.set('x', '<S-Tab>', '<gv', { remap = false })
vim.keymap.set('n', '<Tab>', '>>', { remap = false })
vim.keymap.set('n', '<S-Tab>', '<<', { remap = false })

-- add new lines in normal mode
vim.keymap.set('n', '<CR>', function()
  local n = vim.v.count < 1 and 1 or vim.v.count
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = {}
  local i = 1
  while n >= i do
    lines[i] = ''
    i = i + 1
  end
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, lines)
end, { remap = false })

vim.keymap.set('n', '<S-CR>', function()
  local n = vim.v.count < 1 and 1 or vim.v.count
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = {}
  local i = 1
  while n >= i do
    lines[i] = ''
    i = i + 1
  end
  vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1, false, lines)
end, { remap = false })

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
vim.keymap.set('n', '<Esc>', '<Cmd>noh<CR>')

-- easily exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { remap = false })

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

-- cycle through tabs (reversing order for more intuitive UX)
vim.keymap.set('n', '<C-n>', '<Cmd>BufferLineCyclePrev<CR>', {})
vim.keymap.set('n', '<C-p>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<C-l>', '<Cmd>tabmove +1<CR>', {})
vim.keymap.set('n', '<C-h>', '<Cmd>tabmove -1<CR>', {})
vim.keymap.set('n', '<C-t>', '<cmd>tabnew<cr>', {})

-- copy/cut to clipboard (Linux)
vim.keymap.set({ 'v', 'n' }, '<C-y>', '"+y', { remap = true })
vim.keymap.set({ 'v', 'n' }, '<C-x>', '"+x', { remap = true })

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
vim.keymap.set({ 'i', 'c' }, '<M-BS>', '<C-w>', { remap = false })

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
vim.keymap.set('n', 'zO', 'zR', { remap = true })
-- open all folds descending from current line
vim.keymap.set('n', 'zo', 'zO', { remap = false })
-- fold selected lines
vim.keymap.set('x', '<leader>z', 'zf', { remap = true })
vim.keymap.set('x', 'zz', 'zf', { remap = true })

-- cursor-in-place copy/paste
vim.keymap.set('n', 'P', 'P`[', { remap = false })
vim.keymap.set('x', 'y', 'ygv<Esc>', { remap = false })

local function NextClosedFold(dir)
  local cmd = 'norm!z' .. dir
  local view = vim.fn.winsaveview()
  local l0 = 0
  local l = view.lnum
  local open = true
  while l ~= l0 and open do
    vim.cmd(cmd)
    l0 = l
    l = vim.api.nvim_win_get_cursor(0)[1]
    open = vim.fn.foldclosed(l) < 0
  end
  if open then
    vim.fn.winrestview(view)
  end
end

local function RepeatFoldMove(dir)
  local n = vim.v.count < 1 and 1 or vim.v.count
  while n > 0 do
    NextClosedFold(dir)
    n = n - 1
  end
end

-- only move to closed folds when jumping folds
vim.keymap.set({ 'n', 'x' }, 'zj', function()
  RepeatFoldMove('j')
end, { remap = false })
vim.keymap.set({ 'n', 'x' }, 'zk', function()
  RepeatFoldMove('k')
end, { remap = false })

-- select entire buffer
vim.keymap.set('x', 'aa', function()
  local mode = vim.api.nvim_get_mode().mode == 'V' and '' or 'V'
  return 'ggoG' .. mode
end, { expr = true })

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

-- easier markdown preview alias
vim.cmd('command M MarkdownPreview')

--> END OF MISCELLANEOUS USER COMMANDS <--
