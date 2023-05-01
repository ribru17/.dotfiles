--> BEGINNING OF EZ SEMICOLON VIM EDITION <--

local function trim(s)
  return s:gsub('^%s+', ''):gsub('%s+$', '')
end

local function trimBeg(s)
  return s:gsub('^%s+', '')
end

local function isInFor(s)
  local firstFour = string.sub(trimBeg(s), 1, 4)
  return firstFour == 'for ' or firstFour == 'for('
end

local function isInReturn(s)
  local firstSeven = string.sub(trimBeg(s), 1, 7)
  return firstSeven == 'return ' or firstSeven == 'return' or
      firstSeven == 'return;'
end

local disabled_filetypes = { 'markdown', 'text' }

vim.keymap.set('i', ';', function()
  for k = 1, #disabled_filetypes do
    local v = disabled_filetypes[k]
    if vim.bo.filetype == v then
      return ';'
    end
  end
  local line = vim.api.nvim_get_current_line()
  local last = string.sub(trim(line), -1)
  if isInFor(line) then
    return ';'
  end
  if isInReturn(line) then
    if last == ';' then
      return '<esc>g_'
    else
      return '<esc>g_a;<esc>'
    end
  end
  if last == ';' then
    return '<esc>$a<cr>'
  else
    if string.len(trim(line)) == 0 then
      return ';<esc>==$a<cr>'
    end
    return '<esc>g_a;<cr>'
  end
end, { expr = true })
vim.keymap.set('i', '<M-;>', ';', { remap = false })

--> END OF EZ SEMICOLON VIM EDITION <--
