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

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
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
  end,
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

return M
