--> MISCELLANEOUS KEYMAPS <--
local map = vim.keymap.set

-- prevent remapping of <C-i>; this is usually mapped to <Tab> which is the
-- complement of <C-o>, however I want my tab to be different so I need to tell
-- <C-i> to use the *default* <Tab> behavior rather than my own (to get the best
-- of both worlds)
map('n', '<C-i>', '<Tab>', { remap = false })

local indent_opts = { remap = false, desc = 'VSCode-style block indentation' }
map('x', '<Tab>', '>gv', indent_opts)
map('x', '<S-Tab>', '<gv', indent_opts)
map('n', '<Tab>', '>>', indent_opts)
map('n', '<S-Tab>', '<<', indent_opts)

map('n', '<CR>', function()
  local n = vim.v.count < 1 and 1 or vim.v.count
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = {}
  local i = 1
  while n >= i do
    lines[i] = ''
    i = i + 1
  end
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, lines)
end, { remap = false, desc = 'Add new lines in normal mode' })

map('n', '<S-CR>', function()
  local n = vim.v.count < 1 and 1 or vim.v.count
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = {}
  local i = 1
  while n >= i do
    lines[i] = ''
    i = i + 1
  end
  vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1, false, lines)
end, { remap = false, desc = 'Add new lines in normal mode (above)' })

local smartmove_opts = {
  desc =
  'Move selection smartly, with indentation for `if` statements and such',
}
map('x', 'J', ":m '>+1<CR>gv=gv", smartmove_opts)
map('x', 'K', ":m '<-2<CR>gv=gv", smartmove_opts)

local opsel_opts = { remap = false, desc = 'Easily move other end of selection' }
map('x', '<C-h>', 'oho', opsel_opts)
map('x', '<C-l>', 'olo', opsel_opts)
map('x', '<C-k>', 'oko', opsel_opts)
map('x', '<C-j>', 'ojo', opsel_opts)

local cursorstay_opts = { remap = false, desc = 'Keep cursor in place' }
map('n', 'J', 'mzJ`z', cursorstay_opts)
map('n', '<C-d>', '<C-d>zz', cursorstay_opts)
map('n', '<C-u>', '<C-u>zz', cursorstay_opts)
map('n', 'n', 'nzzzv', cursorstay_opts)
map('n', 'N', 'Nzzzv', cursorstay_opts)

map('x', 's', 'S',
  { remap = true, desc = 'Surround visual selections' })

map('n', '<Esc>', '<Cmd>noh<CR>',
  { desc = 'Clear search highlighting' })

map('t', '<Esc>', '<C-Bslash><C-n>',
  { remap = false, desc = 'Easily exit terminal mode' })

map('n', 'Q', '<nop>', { desc = "Don't enter ex mode by accident" })
-- TODO: find a way to disable `q:` without causing a pause after typing `q`

map('n', '<leader>h',
  ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gIc<Left><Left><Left><Left>',
  { desc = 'Replace instances of hovered word' }
)
map('n', '<leader>H',
  ':%S/<C-r><C-w>/<C-r><C-w>/gcw<Left><Left><Left><Left>',
  { desc = 'Replace instances of hovered word (matching case)' }
)

map('x', '<leader>h', '"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>',
  {
    remap = false,
    desc = [[Crude search & replace visual selection
                 (breaks on multiple lines & special chars)]],
  })

map('n', '<C-n>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Cycle tab left' })
map('n', '<C-p>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Cycle tab right' })
map('n', '<C-l>', '<Cmd>tabmove +1<CR>', { desc = 'Move tab right' })
map('n', '<C-h>', '<Cmd>tabmove -1<CR>', { desc = 'Move tab left' })
map('n', '<C-t>', '<Cmd>tabnew<CR>', { desc = 'New tab' })

map({ 'v', 'n' }, '<C-y>', '"+y',
  { remap = true, desc = 'Copy to clipboard (Linux)' })
map({ 'v', 'n' }, '<C-x>', '"+x',
  { remap = true, desc = 'Cut to clipboard (Linux)' })

local insertnav_opts = { remap = false, desc = 'Navigation while typing' }
map({ 'i', 'c' }, '<C-k>', '<Up>', insertnav_opts)
map({ 'i', 'c' }, '<C-h>', '<Left>', insertnav_opts)
map({ 'i', 'c' }, '<C-j>', '<Down>', insertnav_opts)
map({ 'i', 'c' }, '<C-l>', '<Right>', insertnav_opts)
map({ 'i', 'c' }, '<C-w>', '<C-Right>', insertnav_opts)
map({ 'i', 'c' }, '<C-b>', '<C-Left>', insertnav_opts)
map('i', '<C-e>', '<C-o>e<Right>', insertnav_opts)

map({ 'i', 'c' }, '<M-BS>', '<C-w>',
  { remap = false, desc = 'Delete word in insert mode' })

map({ 'n', 'v', 'i' }, '<C-/>', '<C-_>',
  {
    remap = true,
    desc = 'Make comment work on terminals where <C-/> is literally <C-/>',
  })

map('i', '<C-f>', '<C-t>',
  { remap = true, desc = 'Easier bullet formatting' })

map('n', '<leader>z', 'za',
  { remap = true, desc = 'Toggle current fold' })
map('n', 'zz', 'za', { remap = true, desc = 'Toggle current fold' })
map('n', 'zf', 'zMzv',
  { remap = true, desc = 'Fold all except current' })
map('n', 'zO', 'zR', { remap = true, desc = 'Open all folds' })
map('n', 'zo', 'zO',
  { remap = false, desc = 'Open all folds descending from current line' })
map('x', '<leader>z', 'zf',
  { remap = true, desc = 'Fold selected lines' })
map('x', 'zz', 'zf', { remap = true, desc = 'Fold selected lines' })

map('x', 'y', 'ygv<Esc>',
  { remap = false, desc = 'Cursor-in-place copy' })
map('n', 'P', 'P`[', { remap = false, desc = 'Cursor-in-place paste' })

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

local fold_opts = { remap = false, desc = 'Only jump to *closed* folds' }
map({ 'n', 'x' }, 'zj', function()
  RepeatFoldMove('j')
end, fold_opts)
map({ 'n', 'x' }, 'zk', function()
  RepeatFoldMove('k')
end, fold_opts)

map('x', 'aa', function()
  local mode = vim.api.nvim_get_mode().mode == 'V' and '' or 'V'
  return 'ggoG' .. mode
end, { expr = true, desc = 'Select entire buffer' })

map('n', '<leader>w', function()
  vim.wo.wrap = not vim.wo.wrap
end, { remap = false, desc = 'Toggle word wrap' })

--> END OF MISCELLANEOUS KEYMAPS <--

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--> MISCELLANEOUS USER COMMANDS <--
local create_command = vim.api.nvim_create_user_command

local nofmt_opts = { desc = 'Write without formatting' }
create_command('W', 'noa w', nofmt_opts)
create_command('Wq', 'noa w | q', nofmt_opts)
create_command('Wa', 'noa wa', nofmt_opts)
create_command('Wqa', 'noa wa | qa', nofmt_opts)
create_command('Wn', 'noa wn', nofmt_opts)
create_command('WN', 'noa wN', nofmt_opts)
create_command('Wp', 'noa wp', nofmt_opts)

create_command('M', 'MarkdownPreviewToggle',
  { desc = 'Easier Markdown preview alias' })

--> END OF MISCELLANEOUS USER COMMANDS <--
