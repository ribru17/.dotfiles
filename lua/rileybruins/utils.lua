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

---Converts a hex color code string to a table of integer values
---@param hex_str string: Hex color code of the format `#rrggbb`
---@return table rgb: Table of {r, g, b} integers
local function hexToRgb(hex_str)
  local r, g, b = string.match(hex_str, '^#(%x%x)(%x%x)(%x%x)')
  assert(r, 'Invalid hex string: ' .. hex_str)
  return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

---Blends two hex colors, given a blending amount
---@param fg string: A hex color code of the format `#rrggbb`
---@param bg string: A hex color code of the format `#rrggbb`
---@param alpha number: A blending factor, between `0` and `1`.
---@return string hex: A blended hex color code of the format `#rrggbb`
function M.blend(fg, bg, alpha)
  local bg_rgb = hexToRgb(bg)
  local fg_rgb = hexToRgb(fg)

  local blendChannel = function(i)
    local ret = (alpha * fg_rgb[i] + ((1 - alpha) * bg_rgb[i]))
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

local get_node_insert_mode = function(opts)
  opts = opts or {}
  local ins_curs = cur_pos(0)
  ins_curs[1] = ins_curs[1] - 1
  ins_curs[2] = ins_curs[2] - 1
  opts.pos = ins_curs
  return get_node(opts)
end

local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
  math_environment = true,
}

M.get_md_link_dest = function()
  local current_node = get_node { lang = 'markdown_inline' }
  while current_node do
    local type = current_node:type()
    if type == 'link_destination' then
      return vim.treesitter.get_node_text(current_node, 0)
    elseif type == 'inline_link' or type == 'image' then
      return vim.treesitter.get_node_text(current_node:named_child(1), 0)
    elseif type == 'link_text' or type == 'image_description' then
      return vim.treesitter.get_node_text(current_node:next_named_sibling(), 0)
    end
    current_node = current_node:parent()
  end
  return nil
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

M.in_jsx_tags_insert = function()
  local current_node = get_node_insert_mode()
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
    -- reparse on single-character triggers to make function wait for the main
    -- thread to finish tree-sitter parsing (otherwise single character snippets
    -- will not be recognized if they are the first input in a LaTeX block)
    vim.treesitter.get_parser():parse()
  end
  local current_node = get_node_insert_mode { ignore_injections = false }
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
  return M.in_mathzone(line_to_cursor, matched_trigger)
end

M.in_text = function()
  return not M.in_mathzone()
end

return M
