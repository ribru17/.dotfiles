--> MISCELLANEOUS KEYMAPS <--
local link_dest = require('rileybruins.utils').get_md_link_dest
local map = vim.keymap.set

map('n', '<C-i>', '<Tab>', {
  desc = [[
Prevent remapping of <C-i>; this is usually mapped to <Tab> which is the
complement of <C-o>, however I want my tab to be different so I need to tell
<C-i> to use the *default* <Tab> behavior rather than my own (to get the best
of both worlds).
]],
})

-- TODO: Remove after v0.10
-- Only set this mapping if `xdg-open` is found. If not, we will bite the bullet
-- and load all of the netrw plugin to get this functionality.
if vim.fn.executable('xdg-open') == 1 then
  map('n', 'gx', function()
    local link = link_dest()
    if link then
      vim.fn.system {
        'xdg-open',
        link,
      }
    else
      vim.fn.system {
        'xdg-open',
        vim.fn.expand('<cfile>'),
      }
    end
  end, { desc = 'Netrw-like link opening', silent = true })
end

local indent_opts = { desc = 'VSCode-style block indentation' }
map('x', '<Tab>', function()
  vim.cmd.normal { vim.v.count1 .. '>gv', bang = true }
end, indent_opts)
map('x', '<S-Tab>', function()
  vim.cmd.normal { vim.v.count1 .. '<gv', bang = true }
end, indent_opts)
map('n', '<Tab>', '>>', indent_opts)
map('n', '<S-Tab>', '<<', indent_opts)

map('n', '<leader>sj', ']s', { desc = 'Move to next misspelling' })
map('n', '<leader>sk', '[s', { desc = 'Move to previous misspelling' })

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

local nowhitespacejump_opts = {
  desc = 'Better no-whitespace jumping',
}
map({ 'n', 'x', 'o' }, 'H', '^', nowhitespacejump_opts)
map({ 'n', 'x', 'o' }, 'L', 'g_', nowhitespacejump_opts)

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
map('n', 'J', function()
  local cur = vim.api.nvim_win_get_cursor(0)
  vim.cmd.normal { vim.v.count1 + 1 .. 'J', bang = true }
  vim.api.nvim_win_set_cursor(0, cur)
end, cursorstay_opts)
map({ 'n', 'x' }, '<C-d>', function()
  vim.cmd.normal {
    vim.api.nvim_replace_termcodes('<C-d>', true, false, true) .. 'zz',
    bang = true,
  }
end, cursorstay_opts)
map({ 'n', 'x' }, '<C-u>', function()
  vim.cmd.normal {
    vim.api.nvim_replace_termcodes('<C-u>', true, false, true) .. 'zz',
    bang = true,
  }
end, cursorstay_opts)
map({ 'n', 'x' }, '<C-f>', function()
  vim.cmd.normal {
    vim.api.nvim_replace_termcodes('<C-f>', true, false, true) .. 'zz',
    bang = true,
  }
end, cursorstay_opts)
map({ 'n', 'x' }, '<C-b>', function()
  vim.cmd.normal {
    vim.api.nvim_replace_termcodes('<C-b>', true, false, true) .. 'zz',
    bang = true,
  }
end, cursorstay_opts)
map('n', 'n', 'nzzzv', cursorstay_opts)
map('n', 'N', 'Nzzzv', cursorstay_opts)

map('n', '<Esc>', vim.cmd.noh, { desc = 'Clear search highlighting' })

map('t', '<Esc>', '<C-Bslash><C-n>', { desc = 'Easily exit terminal mode' })

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
  { 'x', 'n' },
  '<C-y>',
  '"+y',
  { remap = true, desc = 'Copy to clipboard (Linux)' }
)
map(
  'n',
  '<C-y><C-y>',
  '"+yy',
  { remap = true, desc = 'Copy to clipboard (Linux)' }
)
map(
  { 'x', 'n' },
  '<C-x>',
  '"+d',
  { remap = true, desc = 'Delete to clipboard (Linux)' }
)

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
map('n', 'zF', function()
  vim.cmd.normal('zMzvzczo')
end, { desc = 'Fold all except current and children of current' })
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

map({ 'x', 'n' }, '<leader>t', function()
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
  vim.cmd.normal('ggVG')
end, { desc = 'Select entire buffer' })
map('x', 'ia', function()
  local mode = vim.api.nvim_get_mode().mode == 'V' and 'v' or ''
  return 'gg0oG$h' .. mode
end, { expr = true, desc = 'Select entire buffer (without final newline)' })
map('o', 'ia', function()
  vim.cmd.normal('gg0vG$')
end, { desc = 'Select entire buffer (without final newline)' })

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

map('n', 'U', '<C-r>', { desc = 'Easier redo' })

map(
  'n',
  '<leader>bx',
  '<Cmd>tabo<CR>',
  { desc = 'Close all but the current tab' }
)

map('n', 'gf', function()
  pcall(function()
    if vim.fn.filereadable(vim.fn.expand('<cfile>')) == 1 then
      vim.cmd.drop { vim.fn.expand('<cfile>'), mods = { tab = 1 } }
    else
      vim.notify("Can't find file " .. vim.fn.expand('<cfile>') .. ' in path')
    end
  end)
end, { desc = 'Smarter Goto File functionality' })

map('n', 'gh', function()
  vim.cmd.h(vim.fn.expand('<cword>'))
end, { desc = 'Get Help under current word' })
map('x', 'gh', function()
  vim.cmd.normal('y')
  vim.cmd.h(vim.fn.getreg('0'))
end, { desc = 'Get Help under current selection' })

map('n', '<leader>sf', function()
  local cur_pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd.normal { '1z=', bang = true }
  vim.api.nvim_win_set_cursor(0, cur_pos)
end, { desc = 'Correct spelling of word under cursor' })
map('n', '<leader>si', function()
  vim.cmd.normal('ysiw`')
end, { desc = 'Ignore spelling of word under cursor' })

if vim.fn.executable('delta') == 1 then
  map('n', '<leader>gc', function()
    vim.cmd.Telescope('delta_git_commits')
  end, { desc = 'Show Git commit history' })
  map('n', '<leader>gh', function()
    vim.cmd.Telescope('delta_git_bcommits')
  end, { desc = 'Show Git commit history for current buffer' })
  map('n', '<leader>gs', function()
    vim.cmd.Telescope('delta_git_status')
  end, { desc = 'Show Git status' })
else
  map('n', '<leader>gc', function()
    vim.cmd.Telescope('git_commits')
  end, { desc = 'Show Git commit history' })
  map('n', '<leader>gh', function()
    vim.cmd.Telescope('git_bcommits')
  end, { desc = 'Show Git commit history for current buffer' })
  map('n', '<leader>gs', function()
    vim.cmd.Telescope('git_status')
  end, { desc = 'Show Git status' })
end

local ll_opts = { desc = 'Easier location list movement' }
map({ 'n', 'x' }, '<leader>lj', function()
  pcall(function()
    vim.cmd.lne {
      count = vim.v.count1,
    }
  end)
end, ll_opts)
map({ 'n', 'x' }, '<leader>lk', function()
  pcall(function()
    vim.cmd.lp {
      count = vim.v.count1,
    }
  end)
end, ll_opts)

map({ 'x', 'o' }, 'ig', function()
  vim.cmd.Gitsigns('select_hunk')
end, { desc = 'Select Inside a Git change' })

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

create_command('I', 'Inspect', { desc = 'Easier Markdown preview alias' })

create_command('IT', 'InspectTree', { desc = 'Easier Markdown preview alias' })

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
  clear('@lsp.type.event')
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
  clear('@lsp.type.struct')
  clear('@lsp.type.type')
  clear('@lsp.type.typeAlias')
  clear('@lsp.type.typeParameter')
  clear('@lsp.type.unresolvedReference')
  clear('@lsp.type.variable')
  clear('@lsp.type.variable.rust')
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
  clear('@lsp.type.builtinAttribute')
  clear('@lsp.type.derive')
  clear('@lsp.typemod.generic.attribute')
end, { desc = 'Clear LSP semantic highlights' })

create_command('DiffKeep', function()
  vim.cmd.diffg('LO')
end, { desc = 'Keep local Git changes' })

create_command('DiffAccept', function()
  vim.cmd.diffg('RE')
end, { desc = 'Accept remote Git changes' })

create_command('Converttomultiplex', function()
  local original = require('bamboo.palette').vulgaris
  local new = require('bamboo.palette').multiplex
  for key, value in pairs(original) do
    pcall(vim.cmd.s, {
      '/' .. value:sub(2) .. '/' .. new[key]:sub(2) .. '/g',
      range = { 1, vim.fn.line('$') },
    })
  end
  -- operator
  pcall(vim.cmd.s, {
    '%s/c5c2ee/c5b0d4/g',
    range = { 1, vim.fn.line('$') },
  })
  -- lightblue
  pcall(vim.cmd.s, {
    '%s/c5c2ee/95bbda/g',
    range = { 1, vim.fn.line('$') },
  })
end, { desc = 'Accept remote Git changes' })

create_command('Converttolight', function()
  local original = require('bamboo.palette').vulgaris
  local new = require('bamboo.palette').light
  for key, value in pairs(original) do
    pcall(vim.cmd.s, {
      '/' .. value:sub(2) .. '/' .. new[key]:sub(2) .. '/g',
      range = { 1, vim.fn.line('$') },
    })
  end
  -- operator
  pcall(vim.cmd.s, {
    '%s/c5c2ee/6c47a0/g',
    range = { 1, vim.fn.line('$') },
  })
  -- lightblue
  pcall(vim.cmd.s, {
    '%s/96c7ef/6e9fe5/g',
    range = { 1, vim.fn.line('$') },
  })
end, { desc = 'Accept remote Git changes' })

local function take_screenshot(opts)
  if vim.env.XDG_CURRENT_DESKTOP == 'KDE' then
    local args = vim.split(opts.fargs[1], ' ')
    local out = args[1] or 'sample.png'
    local delay = args[2] or 100
    vim.fn.jobstart('spectacle -a -o ' .. out .. ' -b -d ' .. delay .. ' -e -S')
    -- clear command area text
    vim.cmd.mod()
  end
end
local ss_cmd_opts =
  { desc = 'Take a screenshot of the terminal contents', nargs = '?' }

create_command('Screenshot', take_screenshot, ss_cmd_opts)
create_command('SS', take_screenshot, ss_cmd_opts)

--> END OF MISCELLANEOUS USER COMMANDS <--
