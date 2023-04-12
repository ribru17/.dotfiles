---@diagnostic disable: undefined-global
local ts = require("nvim-treesitter.parsers")

local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
  math_environment = true,
}

local function get_node_at_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  col = col - 1

  local parser = ts.get_parser(buf, "latex")
  if not parser then
    return
  end
  local root_tree = parser:parse()[1]
  local root = root_tree and root_tree:root()

  if not root then
    return
  end

  return root:named_descendant_for_range(row, col, row, col)
end

local function in_text(check_parent)
  local node = get_node_at_cursor()
  while node do
    if node:type() == "text_mode" then
      if check_parent then
        -- For \text{}
        local parent = node:parent()
        if parent and MATH_NODES[parent:type()] then
          return false
        end
      end

      return true
    elseif MATH_NODES[node:type()] then
      return false
    end
    node = node:parent()
  end
  return true
end

local function in_mathzone()
  local node = get_node_at_cursor()
  while node do
    if node:type() == "text_mode" then
      return false
    elseif MATH_NODES[node:type()] then
      return true
    end
    node = node:parent()
  end
  return false
end

local frac_no_parens = {
  f(function(_, snip)
    return string.format("\\frac{%s}", snip.captures[1])
  end, {}),
  t("{"),
  i(1),
  t("}"),
  i(0),
}

local frac = s({
  priority = 1000,
  trig = ".*%)/",
  wordTrig = true,
  regTrig = true,
}, {
  f(function(_, snip)
    local match = snip.trigger
    local stripped = match:sub(1, #match - 1)

    local k = #stripped
    local depth = 0
    while true do
      if stripped:sub(k, k) == ")" then
        depth = depth + 1
      end
      if stripped:sub(k, k) == "(" then
        depth = depth - 1
      end
      if depth == 0 then
        break
      end
      k = k - 1
    end

    local rv =
        string.format("%s\\frac{%s}", stripped:sub(1, k - 1), stripped:sub(k + 1, #stripped - 1))

    return rv
  end, {}),
  t("{"),
  i(1),
  t("}"),
  i(0),
})

-- local math_wrA = {
-- }

return {}, {
  -- in math
  s({ trig = '*', wordTrig = false, }, fmt([[\cdot]], {}), { condition = in_mathzone }),
  s({ trig = '<=', wordTrig = false, }, fmt([[\le]], {}), { condition = in_mathzone }),
  s({ trig = '>=', wordTrig = false, }, fmt([[\ge]], {}), { condition = in_mathzone }),
  s({ trig = '~~', wordTrig = false, }, fmt([[\approx]], {}), { condition = in_mathzone }),
  s({ trig = '=> ', wordTrig = false, }, fmt([[\implies ]], {}), { condition = in_mathzone }),
  s({ trig = '=<', wordTrig = false, }, fmt([[\impliedby]], {}), { condition = in_mathzone }),
  s({ trig = '>> ', wordTrig = false, }, fmt([[\gg ]], {}), { condition = in_mathzone }),
  s({ trig = '<<', wordTrig = false, }, fmt([[\ll]], {}), { condition = in_mathzone }),
  s({ trig = '!=', wordTrig = false, }, fmt([[\neq]], {}), { condition = in_mathzone }),
  s({ trig = 'nabla', wordTrig = false, }, fmt([[\nabla]], {}), { condition = in_mathzone }),
  s({ trig = 'EE', wordTrig = false, }, fmt([[\exists]], {}), { condition = in_mathzone }),
  s({ trig = 'AA', wordTrig = false, }, fmt([[\forall]], {}), { condition = in_mathzone }),
  s({ trig = 'notin', wordTrig = false, }, fmt([[\not\in]], {}), { condition = in_mathzone }),
  s({ trig = 'cc', wordTrig = false, }, fmt([[\subset]], {}), { condition = in_mathzone }),
  s({ trig = '<-> ', wordTrig = false, }, fmt([[\leftrightarrow ]], {}), { condition = in_mathzone }),
  s({ trig = '...', wordTrig = false, }, fmt([[\ldots]], {}), { condition = in_mathzone }),
  s({ trig = 'iff', wordTrig = false, }, fmt([[\iff]], {}), { condition = in_mathzone }),
  s({ trig = 'inf', wordTrig = false, }, fmt([[\infty]], {}), { condition = in_mathzone }),
  s({ trig = '//', wordTrig = false, }, fmt([[\frac{{{1}}}{{{2}}}]], { i(1, 'a'), i(2, 'b') }),
    { condition = in_mathzone }),
  s(
    {
      trig = "(%a)bar",
      wordTrig = false,
      regTrig = true,
      priority = 100,
    },
    f(function(_, snip)
      return string.format("\\overline{%s}", snip.captures[1])
    end, {})
  ),
  -- in math, word boundary
  frac,

  s({
    trig = "([%a])(%d)",
    regTrig = true,
  }, {
    f(function(_, snip)
      return string.format("%s_%s", snip.captures[1], snip.captures[2])
    end, {}),
    i(0),
  }),

  s({
    trig = "([%a])_(%d%d)",
    regTrig = true,
  }, {
    f(function(_, snip)
      return string.format("%s_{%s}", snip.captures[1], snip.captures[2])
    end, {}),
    i(0),
  }),

  s({
    trig = "(\\?[%w]+\\?^%w)/",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = "(\\?[%w]+\\?_%w)/",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = "(\\?[%w]+\\?^{%w*})/",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = "(\\?[%w]+\\?_{%w*})/",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = "(\\?%w+)/",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens)),
  -- not in math
  s({ trig = 'dm', }, fmt(
    [[
    $$
    {1}
    $$
    ]],
    { i(1, "") }), { condition = in_text }),
  s({ trig = 'mk', }, fmt([[${}$]], { i(1) }), { condition = in_text }),
}
