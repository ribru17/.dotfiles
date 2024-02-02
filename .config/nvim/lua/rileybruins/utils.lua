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

---An insert mode implementation of `vim.treesitter`'s `get_node`
---@param opts table? Opts to be passed to `get_node`
---@return TSNode node The node at the cursor
local get_node_insert_mode = function(opts)
  opts = opts or {}
  local ins_curs = cur_pos(0)
  ins_curs[1] = ins_curs[1] - 1
  ins_curs[2] = ins_curs[2] - 1
  opts.pos = ins_curs
  return get_node(opts)
end

---Returns the destination of the Markdown link at the cursor (if any)
---@return string?
M.get_md_link_dest = function()
  -- NOTE: Maybe in the future make this work for injected Markdown used in e.g.
  -- documentation?
  if vim.bo.filetype ~= 'markdown' then
    return
  end
  local current_node = get_node { ignore_injections = false }
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

---Whether or not the cursor is in a JSX-tag region
---@param insert_mode boolean Whether or not the cursor is in insert mode
---@return boolean
M.in_jsx_tags = function(insert_mode)
  local current_node = insert_mode and get_node_insert_mode() or get_node()
  while current_node do
    if current_node:type() == 'jsx_element' then
      return true
    end
    current_node = current_node:parent()
  end
  return false
end

local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
  math_environment = true,
}

---Whether or not the cursor is in a LaTeX block
---@return boolean
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

---Whether or not the cursor is in a LaTeX math zone
---@param _ any
---@param matched_trigger string? The matched snippet trigger
---@return boolean
M.in_mathzone = function(_, matched_trigger)
  if matched_trigger and matched_trigger:len() == 1 then
    -- reparse on single-character triggers to make function wait for the main
    -- thread to finish tree-sitter parsing (otherwise single character snippets
    -- will not be recognized if they are the first input in a LaTeX block)
    vim.treesitter.get_parser():parse()
  end
  -- NOTE: This must not be set to `lang = 'latex'`; all injection context is
  -- lost and the entire buffer is erroneously parsed as LaTeX, leading to
  -- incorrect snippet evaluation.
  local current_node = get_node_insert_mode { ignore_injections = false }
  while current_node do
    if current_node:type() == 'text_mode' then
      return false
    elseif current_node:type() == 'generic_command' then
      local cmd_name =
        vim.treesitter.get_node_text(current_node:named_child(0), 0, {})
      if cmd_name == '\\textbf' or cmd_name == '\\textit' then
        return false
      end
    elseif MATH_NODES[current_node:type()] then
      return true
    end
    current_node = current_node:parent()
  end
  return false
end

---Whether or not the cursor is in a LaTeX math zone
---@param line_to_cursor string? The line up to the cursor
---@param matched_trigger string? The matched snippet trigger
---@return boolean
M.in_mathzone_ignore_backslash = function(line_to_cursor, matched_trigger)
  if line_to_cursor and line_to_cursor:match('.*\\[%a_]+$') then
    return false
  end
  return M.in_mathzone(line_to_cursor, matched_trigger)
end

M.in_text = function()
  return not M.in_mathzone()
end

-->> THE FOLLOWING FORMATTING CODE IS COURTESY OF https://github.com/lucario387

local ts = vim.treesitter
local get_node_text = ts.get_node_text

--- Control the indent here. Change to \t if uses tab instead
local indent_str = '  '

---@param lines string[]
---@param lines_to_append string[]
local function append_lines(lines, lines_to_append)
  for i = 1, #lines_to_append, 1 do
    lines[#lines] = lines[#lines] .. lines_to_append[i]
    if i ~= #lines_to_append then
      lines[#lines + 1] = ''
    end
  end
end

---@param bufnr integer
---@param node TSNode
---@param lines string[]
---@param q table<string, TSMetadata>
---@param level integer
local function iter(bufnr, node, lines, q, level)
  --- Sometimes 2 queries apply append twice. This is to prevent the case from happening
  local apply_newline = false
  for child, _ in node:iter_children() do
    local id = child:id()
    repeat
      if apply_newline then
        apply_newline = false
        lines[#lines + 1] = string.rep(indent_str, level)
      end
      if q['format.ignore'][id] then
        local text = vim.split(
          get_node_text(child, bufnr):gsub('\r\n?', '\n'),
          '\n',
          { trimempty = true }
        )
        append_lines(lines, text)
        break
      elseif q['format.remove'][id] then
        break
      end
      if not q['format.cancel-prepend'][id] then
        if q['format.prepend-newline'][id] then
          lines[#lines + 1] = string.rep(indent_str, level)
        elseif q['format.prepend-space'][id] then
          lines[#lines] = lines[#lines] .. ' '
        end
      end
      if q['format.replace'][id] then
        append_lines(
          lines,
          ---@diagnostic disable-next-line: param-type-mismatch
          vim.split(q['format.replace'][id].text, '\n', { trimempty = true })
        )
      elseif child:named_child_count() == 0 or q['format.keep'][id] then
        append_lines(
          lines,
          vim.split(
            string.gsub(get_node_text(child, bufnr), '\r\n?', '\n'),
            '\n+',
            { trimempty = true }
          )
        )
      else
        iter(bufnr, child, lines, q, level)
      end
      if q['format.indent.begin'][id] then
        level = level + 1
        apply_newline = true
        break
      end
      if q['format.indent.dedent'][id] then
        if
          string.match(lines[#lines], '^%s*' .. get_node_text(child, bufnr))
        then
          lines[#lines] =
            string.sub(lines[#lines], 1 + #string.rep(indent_str, 1))
        end
      end
      if q['format.indent.end'][id] then
        level = math.max(level - 1, 0)
        if
          string.match(lines[#lines], '^%s*' .. get_node_text(child, bufnr))
        then
          lines[#lines] =
            string.sub(lines[#lines], 1 + #string.rep(indent_str, 1))
        end
        break
      end
    until true
    repeat
      if q['format.cancel-append'][id] then
        apply_newline = false
      end
      if not q['format.cancel-append'][id] then
        if q['format.append-newline'][id] then
          apply_newline = true
        elseif q['format.append-space'][id] then
          lines[#lines] = lines[#lines] .. ' '
        end
      end
    until true
  end
end

---@param bufnr integer
M.format_query_buf = function(bufnr)
  local lines = { '' }
  -- stylua: ignore
  local map = {
    ['format.ignore'] = {},           -- Ignore the node and its children
    ['format.indent.begin'] = {},     -- +1 shiftwidth for all nodes after this
    ['format.indent.end'] = {},       -- -1 shiftwidth for all nodes after this
    ['format.indent.dedent'] = {},    -- -1 shiftwidth for this line only
    ['format.prepend-space'] = {},    -- Prepend a space before inserting the node
    ['format.prepend-newline'] = {},  -- Prepend a \n before inserting the node
    ['format.append-space'] = {},     -- Append a space after inserting the node
    ['format.append-newline'] = {},   -- Append a newline after inserting the node
    ['format.cancel-append'] = {},    -- Cancel any `@format.append-*` applied to the node
    ['format.cancel-prepend'] = {},   -- Cancel any `@format.prepend-*` applied to the node
    ['format.keep'] = {},             -- String content is not exposed as a syntax node. This is a workaround for it
    ['format.replace'] = {},          -- Dedicated capture used to store results of `(#gsub!)`
    ['format.remove'] = {},           -- Do not add the syntax node to the result, i.e. brackets [], parens ()
  }
  local root = ts.get_parser(bufnr, 'query'):parse(true)[1]:root()
  local query = ts.query.get('query', 'formats')
  for id, node, metadata in query:iter_captures(root, bufnr) do
    if query.captures[id]:sub(1, 1) ~= '_' then
      map[query.captures[id]][node:id()] = metadata
          and (metadata[id] and metadata[id] or metadata)
        or {}
    end
  end

  iter(bufnr, root, lines, map, 0)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

-->> END OF QUERY FORMATTING

return M
