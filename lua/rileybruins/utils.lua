local M = {}
local sat = 40
local inc = -1
local timer = nil
local color = string.format(
  '#%x',
  vim.api.nvim_get_hl_by_name('@alpha.title', true).foreground or 16777215
)
local background = string.format(
  '#%x',
  vim.api.nvim_get_hl_by_name('Normal', true).background or 16777215
)

local function hexToRgb(hex_str)
  local hex = '[abcdef0-9][abcdef0-9]'
  local pat = '^#(' .. hex .. ')(' .. hex .. ')(' .. hex .. ')$'
  hex_str = string.lower(hex_str)

  assert(
    string.find(hex_str, pat) ~= nil,
    'hex_to_rgb: invalid hex_str: ' .. tostring(hex_str)
  )

  local r, g, b = string.match(hex_str, pat)
  return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

function M.blend(fg, bg, alpha)
  bg = hexToRgb(bg)
  fg = hexToRgb(fg)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format(
    '#%02X%02X%02X',
    blendChannel(1),
    blendChannel(2),
    blendChannel(3)
  )
end

M.update_colors = function()
  vim.api.nvim_set_hl(
    0,
    '@alpha.title',
    { link = 'Structure', default = false }
  )
  vim.api.nvim_set_hl(
    0,
    '@alpha.header',
    { fg = vim.api.nvim_get_hl(0, { name = 'String' }).fg, bold = true }
  )
  vim.api.nvim_set_hl(
    0,
    '@alpha.footer',
    { fg = vim.api.nvim_get_hl(0, { name = 'Constant' }).fg, italic = true }
  )
  background = string.format(
    '#%x',
    vim.api.nvim_get_hl_by_name('Normal', true).background or 0
  )
  color = string.format(
    '#%x',
    vim.api.nvim_get_hl_by_name('@alpha.title', true).foreground or 0
  )
  if background:len() ~= 7 then
    background = '#ffffff'
  end
  if color:len() ~= 7 then
    color = '#ffffff'
  end
end

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = M.update_colors,
})

function M.color_fade_start()
  if timer then
    return
  end

  timer = vim.loop.new_timer()
  timer:start(
    50,
    50,
    vim.schedule_wrap(function()
      sat = sat + inc
      if sat >= 40 or sat <= 0 then
        inc = -1 * inc
      end
      local blended = M.blend(color, background, sat / 40)
      vim.api.nvim_set_hl(0, '@alpha.title', { fg = blended })
    end)
  )
end

function M.color_fade_stop()
  if not timer then
    return
  end

  timer:stop()
  timer:close()
  timer = nil
end

local get_node = vim.treesitter.get_node
local cur_pos = vim.api.nvim_win_get_cursor
local get_node_insert_mode = function()
  local ins_curs = cur_pos(0)
  ins_curs[1] = ins_curs[1] - 1
  ins_curs[2] = ins_curs[2] - 1
  return get_node { ignore_injections = false, pos = ins_curs }
end

local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
  math_environment = true,
}

local LINK_NODES = {
  image = true,
  image_description = true,
  inline_link = true,
  link_text = true,
}

M.in_md_link_text = function()
  local current_node = get_node { ignore_injections = false }
  while current_node do
    if current_node:type() == 'link_destination' then
      return false
    elseif LINK_NODES[current_node:type()] then
      return true
    end
    current_node = current_node:parent()
  end
  return false
end

M.in_jsx_tags = function()
  local current_node = get_node()
  while current_node do
    if current_node:type() == 'jsx_element' then
      return true
    end
    current_node = current_node:parent()
  end
  return false
end

M.in_latex_zone = function()
  local current_node = get_node { ignore_injections = false }
  while current_node do
    if MATH_NODES[current_node:type()] then
      return true
    end
    current_node = current_node:parent()
  end
  return false
end

M.in_mathzone = function(_, matched_trigger)
  if matched_trigger and matched_trigger:len() == 1 then
    -- redraw on single-character triggers to make function wait for the main
    -- thread to finish tree-sitter parsing
    vim.cmd.redraw()
  end
  local current_node = get_node_insert_mode()
  while current_node do
    if current_node:type() == 'text_mode' then
      return false
    elseif MATH_NODES[current_node:type()] then
      return true
    end
    current_node = current_node:parent()
  end
  return false
end

M.in_mathzone_ignore_backslash = function(line_to_cursor, matched_trigger)
  if line_to_cursor and line_to_cursor:match('.*\\[%a_]+$') then
    return false
  end
  if matched_trigger and matched_trigger:len() == 1 then
    -- redraw on single-character triggers to make function wait for the main
    -- thread to finish tree-sitter parsing
    vim.cmd.redraw()
  end
  local current_node = get_node_insert_mode()
  while current_node do
    if current_node:type() == 'text_mode' then
      return false
    elseif MATH_NODES[current_node:type()] then
      return true
    end
    current_node = current_node:parent()
  end
  return false
end

M.in_text = function()
  return not M.in_mathzone()
end

return M
