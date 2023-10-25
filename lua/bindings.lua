--> MISCELLANEOUS KEYMAPS <--
local map = vim.keymap.set

map('n', '<C-i>', '<Tab>', {
  desc = [[
Prevent remapping of <C-i>; this is usually mapped to <Tab> which is the
complement of <C-o>, however I want my tab to be different so I need to tell
<C-i> to use the *default* <Tab> behavior rather than my own (to get the best
of both worlds).
]],
})

local indent_opts = { desc = 'VSCode-style block indentation' }
map('x', '<Tab>', function()
  vim.cmd.normal { vim.v.count1 .. '>gv', bang = true }
end, indent_opts)
map('x', '<S-Tab>', function()
  vim.cmd.normal { vim.v.count1 .. '<gv', bang = true }
end, indent_opts)
map('n', '<Tab>', '>>', indent_opts)
map('n', '<S-Tab>', '<<', indent_opts)

local math_obj_opts = {
  desc = 'Custom text object to delete inside "$" delimiters',
}
map('x', 'i$', function()
  require('nvim-treesitter.textobjects.select').select_textobject(
    '@math.inner',
    'textobjects',
    'v'
  )
end, math_obj_opts)
map('x', 'a$', function()
  require('nvim-treesitter.textobjects.select').select_textobject(
    '@math.outer',
    'textobjects',
    'v'
  )
end, math_obj_opts)
map('o', 'i$', function()
  require('nvim-treesitter.textobjects.select').select_textobject(
    '@math.inner',
    'textobjects',
    'o'
  )
end, math_obj_opts)
map('o', 'a$', function()
  require('nvim-treesitter.textobjects.select').select_textobject(
    '@math.outer',
    'textobjects',
    'o'
  )
end, math_obj_opts)

map('n', '<CR>', function()
  local n = vim.v.count1
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = {}
  local i = 1
  while n >= i do
    lines[i] = ''
    i = i + 1
  end
  -- pcall suppresses annoying errors when trying to edit read-only buffer
  pcall(function()
    vim.api.nvim_buf_set_lines(0, current_line, current_line, false, lines)
  end)
end, { desc = 'Add new lines in normal mode' })

map('n', '<S-CR>', function()
  local n = vim.v.count1
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = {}
  local i = 1
  while n >= i do
    lines[i] = ''
    i = i + 1
  end
  -- pcall suppresses annoying errors when trying to edit read-only buffer
  pcall(function()
    vim.api.nvim_buf_set_lines(
      0,
      current_line - 1,
      current_line - 1,
      false,
      lines
    )
  end)
end, { desc = 'Add new lines in normal mode (above)' })

local smartmove_opts = {
  desc = 'Move selection smartly, with indentation for `if` statements and such',
}
map('x', 'J', ":m '>+1<CR>gv=gv", smartmove_opts)
map('x', 'K', ":m '<-2<CR>gv=gv", smartmove_opts)

local nowhitespacejump_opts = {
  desc = 'Better no-whitespace jumping',
}
map({ 'n', 'x' }, 'H', '_', nowhitespacejump_opts)
map({ 'n', 'x' }, 'L', 'g_', nowhitespacejump_opts)

local opsel_opts = { desc = 'Easily move other end of selection' }
map('x', '<C-h>', function()
  vim.cmd.normal('oho')
end, opsel_opts)
map('x', '<C-l>', function()
  vim.cmd.normal('olo')
end, opsel_opts)
map('x', '<C-k>', function()
  vim.cmd.normal('oko')
end, opsel_opts)
map('x', '<C-j>', function()
  vim.cmd.normal('ojo')
end, opsel_opts)

local cursorstay_opts = { desc = 'Keep cursor in place' }
map('n', 'J', 'mzJ`z', cursorstay_opts)
map('n', '<C-d>', function()
  vim.cmd.normal {
    vim.api.nvim_replace_termcodes('<C-d>', true, false, true) .. 'zz',
    bang = true,
  }
end, cursorstay_opts)
map('n', '<C-u>', function()
  vim.cmd.normal {
    vim.api.nvim_replace_termcodes('<C-u>', true, false, true) .. 'zz',
    bang = true,
  }
end, cursorstay_opts)
map('n', 'n', 'nzzzv', cursorstay_opts)
map('n', 'N', 'Nzzzv', cursorstay_opts)

map('n', '<Esc>', '<Cmd>noh<CR>', { desc = 'Clear search highlighting' })

map('t', '<Esc>', '<C-Bslash><C-n>', { desc = 'Easily exit terminal mode' })

map('n', 'Q', '<nop>', { desc = "Don't enter ex mode by accident" })

map(
  'n',
  '<leader>h',
  ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gIc<Left><Left><Left><Left>',
  { desc = 'Replace instances of hovered word' }
)
map(
  'n',
  '<leader>H',
  ':%S/<C-r><C-w>/<C-r><C-w>/gcw<Left><Left><Left><Left>',
  { desc = 'Replace instances of hovered word (matching case)' }
)

map('x', '<leader>h', '"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>', {
  desc = [[Crude search & replace visual selection
                 (breaks on multiple lines & special chars)]],
})

map('n', '<C-n>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Cycle tab left' })
map('n', '<C-p>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Cycle tab right' })
map('n', '<C-l>', '<Cmd>tabmove +1<CR>', { desc = 'Move tab right' })
map('n', '<C-h>', '<Cmd>tabmove -1<CR>', { desc = 'Move tab left' })
map('n', '<C-t>', '<Cmd>tabnew<CR>', { desc = 'New tab' })

map(
  { 'v', 'n' },
  '<C-y>',
  '"+y',
  { remap = true, desc = 'Copy to clipboard (Linux)' }
)
map(
  { 'v', 'n' },
  '<C-x>',
  '"+x',
  { remap = true, desc = 'Cut to clipboard (Linux)' }
)

map('x', '<leader>p', function()
  vim.cmd.normal { '"_dP', bang = true }
end, { desc = "Don't copy pasted-over text" })

local insertnav_opts = { desc = 'Navigation while typing' }
map({ 'i', 'c' }, '<C-k>', '<Up>', insertnav_opts)
map({ 'i', 'c' }, '<C-h>', '<Left>', insertnav_opts)
map({ 'i', 'c' }, '<C-j>', '<Down>', insertnav_opts)
map({ 'i', 'c' }, '<C-l>', '<Right>', insertnav_opts)
map({ 'i', 'c' }, '<C-w>', '<C-Right>', insertnav_opts)
map({ 'i', 'c' }, '<C-b>', '<C-Left>', insertnav_opts)
map('i', '<C-e>', '<C-o>e<Right>', insertnav_opts)

map({ 'i', 'c' }, '<M-BS>', '<C-w>', { desc = 'Delete word in insert mode' })

map({ 'n', 'v', 'i' }, '<C-/>', '<C-_>', {
  remap = true,
  desc = 'Make comment work on terminals where <C-/> is literally <C-/>',
})

map('i', '<C-f>', '<C-t>', { remap = true, desc = 'Easier bullet formatting' })

map('n', '<leader>z', 'za', { desc = 'Toggle current fold' })
map('x', '<leader>z', 'zf', { desc = 'Create fold from selection' })
map('n', 'zf', function()
  vim.cmd.normal('zMzv')
end, { desc = 'Fold all except current' })
map('n', 'zO', function()
  vim.cmd.normal('zR')
end, { desc = 'Open all folds' })
map('n', 'zo', 'zO', { desc = 'Open all folds descending from current line' })

map('x', 'y', 'ygv<Esc>', { desc = 'Cursor-in-place copy' })
map('n', 'P', function()
  vim.cmd.normal { vim.v.count1 .. 'P`[', bang = true }
end, { desc = 'Cursor-in-place paste' })

map('i', '<C-p>', '<C-r>"', { desc = 'Paste from register in insert mode' })
map('i', '<C-n>', '<Nop>', { desc = 'Disable default autocompletion menu' })

vim.keymap.set({ 'x', 'n' }, '<leader>t', function()
  local win = vim.api.nvim_get_current_win()
  local cur = vim.api.nvim_win_get_cursor(win)
  local vstart = vim.fn.getpos('v')[2]
  local current_line = vim.fn.line('.')
  local set_cur = vim.api.nvim_win_set_cursor
  if vstart == current_line then
    vim.cmd.yank()
    require('Comment.api').toggle.linewise.current()
    vim.cmd.put()
    set_cur(win, { cur[1] + 1, cur[2] })
  else
    if vstart < current_line then
      vim.cmd(':' .. vstart .. ',' .. current_line .. 'y')
      vim.cmd.put()
      set_cur(win, { vim.fn.line('.'), cur[2] })
    else
      vim.cmd(':' .. current_line .. ',' .. vstart .. 'y')
      set_cur(win, { vstart, cur[2] })
      vim.cmd.put()
      set_cur(win, { vim.fn.line('.'), cur[2] })
    end
    require('Comment.api').toggle.linewise(vim.fn.visualmode())
  end
end, { silent = true, desc = 'Comment and duplicate selected lines' })

map('x', 'aa', function()
  local mode = vim.api.nvim_get_mode().mode == 'V' and '' or 'V'
  return 'ggoG' .. mode
end, { expr = true, desc = 'Select entire buffer' })
map('o', 'aa', function()
  vim.cmd.normal('gg0vG$')
end, { desc = 'Select entire buffer' })

map('x', 'il', '_og_', { desc = 'Select text content of current line' })
map('o', 'il', function()
  vim.cmd.normal('_vg_')
end, { desc = 'Select text content of current line' })

map('x', 'al', '0o$h', { desc = 'Select current line' })
map('o', 'al', function()
  vim.cmd.normal('0v$h')
end, { desc = 'Select current line' })

map('n', '<leader>w', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = 'Toggle word wrap' })

map('n', '<leader>cc', function()
  if vim.wo.concealcursor:find('n') then
    vim.wo.concealcursor = vim.wo.concealcursor:gsub('n', '')
  else
    vim.wo.concealcursor = vim.wo.concealcursor .. 'n'
  end
end, { desc = 'Toggle word wrap' })

map('n', 'U', '<C-r>', { desc = 'Easier redo' })

map('n', '<leader>bx', function()
  local current_buf = vim.api.nvim_get_current_buf()
  local all_bufs = vim.api.nvim_list_bufs()

  for _, buf in ipairs(all_bufs) do
    if buf ~= current_buf and vim.fn.getbufinfo(buf)[1].changed ~= 1 then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { desc = 'Close all but the current buffer' })

map('n', 'gf', function()
  pcall(function()
    if vim.fn.filereadable(vim.fn.expand('<cfile>')) == 1 then
      vim.cmd.drop { vim.fn.expand('<cfile>'), mods = { tab = 1 } }
    end
  end)
end, { desc = 'Smarter Goto File functionality' })

map('n', '<leader>s', function()
  local cur_pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd.normal { '1z=', bang = true }
  vim.api.nvim_win_set_cursor(0, cur_pos)
end, { desc = 'Correct spelling of word under cursor' })

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

create_command(
  'M',
  'MarkdownPreviewToggle',
  { desc = 'Easier Markdown preview alias' }
)

create_command('DiffFormat', function()
  local lines = vim.fn.system('git diff --unified=0'):gmatch('[^\n\r]+')
  local ranges = {}
  for line in lines do
    if line:find('^@@') then
      local line_nums = line:match('%+.- ')
      if line_nums:find(',') then
        local _, _, first, second = line_nums:find('(%d+),(%d+)')
        table.insert(ranges, {
          start = { tonumber(first), 0 },
          ['end'] = { tonumber(first) + tonumber(second), 0 },
        })
      else
        local first = tonumber(line_nums:match('%d+'))
        table.insert(ranges, {
          start = { first, 0 },
          ['end'] = { first + 1, 0 },
        })
      end
    end
  end
  local format = require('conform').format
  for _, range in pairs(ranges) do
    format {
      range = range,
    }
  end
end, { desc = 'Format changed lines' })

create_command('ClearSem', function()
  local set_hl = vim.api.nvim_set_hl
  local function clear(hl)
    set_hl(0, hl, {})
  end
  clear('@lsp.mod.readonly')
  clear('@lsp.mod.typeHint')
  clear('@lsp.type.boolean')
  clear('@lsp.type.builtinConstant')
  clear('@lsp.type.builtinType')
  clear('@lsp.type.comment')
  clear('@lsp.type.decorator')
  clear('@lsp.type.deriveHelper')
  clear('@lsp.type.enum')
  clear('@lsp.type.enumMember')
  clear('@lsp.type.escapeSequence')
  clear('@lsp.type.formatSpecifier')
  clear('@lsp.type.function')
  clear('@lsp.type.generic')
  clear('@lsp.type.interface')
  clear('@lsp.type.keyword')
  clear('@lsp.type.lifetime')
  clear('@lsp.type.macro')
  clear('@lsp.type.magicFunction')
  clear('@lsp.type.method')
  clear('@lsp.type.namespace')
  clear('@lsp.type.number')
  clear('@lsp.type.operator')
  clear('@lsp.type.parameter')
  clear('@lsp.type.property')
  clear('@lsp.type.selfKeyword')
  clear('@lsp.type.selfTypeKeyword')
  clear('@lsp.type.string')
  clear('@lsp.type.type')
  clear('@lsp.type.typeAlias')
  clear('@lsp.type.typeParameter')
  clear('@lsp.type.unresolvedReference')
  clear('@lsp.type.variable')
  clear('@lsp.type.variable.c')
  clear('@lsp.typemod.class.defaultLibrary')
  clear('@lsp.typemod.enum.defaultLibrary')
  clear('@lsp.typemod.enumMember.defaultLibrary')
  clear('@lsp.typemod.function.defaultLibrary')
  clear('@lsp.typemod.function.readonly')
  clear('@lsp.typemod.keyword.async')
  clear('@lsp.typemod.keyword.injected')
  clear('@lsp.typemod.macro.defaultLibrary')
  clear('@lsp.typemod.method.defaultLibrary')
  clear('@lsp.typemod.method.readonly')
  clear('@lsp.typemod.operator.injected')
  clear('@lsp.typemod.parameter.mutable.rust')
  clear('@lsp.typemod.parameter.readonly')
  clear('@lsp.type.class')
  clear('@lsp.typemod.property.readonly')
  clear('@lsp.typemod.string.injected')
  clear('@lsp.typemod.struct.defaultLibrary')
  clear('@lsp.typemod.type.defaultLibrary')
  clear('@lsp.typemod.typeAlias.defaultLibrary')
  clear('@lsp.typemod.variable.callable')
  clear('@lsp.typemod.variable.constant.rust')
  clear('@lsp.typemod.variable.defaultLibrary')
  clear('@lsp.typemod.variable.global')
  clear('@lsp.typemod.variable.injected')
  clear('@lsp.typemod.variable.mutable.rust')
  clear('@lsp.typemod.variable.static')
  clear('@lsp.typemod.variable.static.rust')
end, { desc = 'Clear LSP semantic highlights' })

--> END OF MISCELLANEOUS USER COMMANDS <--
