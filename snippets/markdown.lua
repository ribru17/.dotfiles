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
  s({ trig = '//', wordTrig = false, }, fmt([[\frac{{{1}}}{{{2}}}]], { i(1, 'a'), i(2, 'b') }),
    { condition = in_mathzone }),
  s({ trig = 'EE', wordTrig = false, }, fmt([[\exists]], {}), { condition = in_mathzone }),
  s({ trig = 'AA', wordTrig = false, }, fmt([[\forall]], {}), { condition = in_mathzone }),
  s({ trig = 'notin', wordTrig = false, }, fmt([[\not\in]], {}), { condition = in_mathzone }),
  s({ trig = 'cc', wordTrig = false, }, fmt([[\subset]], {}), { condition = in_mathzone }),
  s({ trig = '<-> ', wordTrig = false, }, fmt([[\leftrightarrow ]], {}), { condition = in_mathzone }),
  s({ trig = '...', wordTrig = false, }, fmt([[\ldots]], {}), { condition = in_mathzone }),
  s({ trig = 'iff', wordTrig = false, }, fmt([[\iff]], {}), { condition = in_mathzone }),
  s({ trig = 'in', wordTrig = false, }, fmt([[\in]], {}), { condition = in_mathzone }),
  s({ trig = 'to', wordTrig = false, }, fmt([[\to]], {}), { condition = in_mathzone }),
  s({ trig = 'sqrt', wordTrig = false, }, fmt([[\sqrt{{{1}}}]], { i(1, '') }), { condition = in_mathzone }),
  s({ trig = 'inf', wordTrig = false, }, fmt([[\infty]], {}), { condition = in_mathzone }),
  s({ trig = '<> ', wordTrig = false, }, fmt([[\diamond ]], {}), { condition = in_mathzone }),
  s({ trig = 'xnn', wordTrig = false, }, t([[x_{n}]]), { condition = in_mathzone }),
  s({ trig = 'ynn', wordTrig = false, }, t([[y_{n}]]), { condition = in_mathzone }),
  s({ trig = 'xii', wordTrig = false, }, t([[x_{i}]]), { condition = in_mathzone }),
  s({ trig = 'yii', wordTrig = false, }, t([[y_{i}]]), { condition = in_mathzone }),
  s({ trig = 'xjj', wordTrig = false, }, t([[x_{j}]]), { condition = in_mathzone }),
  s({ trig = 'yjj', wordTrig = false, }, t([[y_{j}]]), { condition = in_mathzone }),
  s({ trig = 'xp1', wordTrig = false, }, t([[x_{n+1}]]), { condition = in_mathzone }),
  s({ trig = 'xmm', wordTrig = false, }, t([[x_{m}]]), { condition = in_mathzone }),
  s({ trig = 'dint', wordTrig = false, },
    fmt([[\int_{{{1}}}^{{{2}}}{3}]], { i(1, [[-\infty]]), i(2, [[\infty]]), i(3, '') }), { condition = in_mathzone }),
  s({ trig = 'ceil', wordTrig = false, }, fmt([[\lceil {1}\rceil{2}]], { i(1, ''), i(2, '') }),
    { condition = in_mathzone }),
  s({ trig = 'floor', wordTrig = false, }, fmt([[\lfloor {1}\rfloor{2}]], { i(1, ''), i(2, '') }),
    { condition = in_mathzone }),
  s({ trig = 'RR', wordTrig = false, }, fmt([[\mathbb{{R}}]], {}), { condition = in_mathzone }),
  s({ trig = 'ZZ', wordTrig = false, }, fmt([[\mathbb{{Z}}]], {}), { condition = in_mathzone }),
  s({ trig = 'QQ', wordTrig = false, }, fmt([[\mathbb{{Q}}]], {}), { condition = in_mathzone }),
  s({ trig = 'NN', wordTrig = false, }, fmt([[\mathbb{{N}}]], {}), { condition = in_mathzone }),
  s({ trig = 'DD', wordTrig = false, }, fmt([[\mathbb{{D}}]], {}), { condition = in_mathzone }),
  s({ trig = 'HH', wordTrig = false, }, fmt([[\mathbb{{H}}]], {}), { condition = in_mathzone }),
  s({ trig = 'nn', wordTrig = false, }, fmt([[\cap]], {}), { condition = in_mathzone }),
  s({ trig = 'UU', wordTrig = false, }, fmt([[\cup]], {}), { condition = in_mathzone }),
  s({ trig = 'empty', wordTrig = false, }, fmt([[\emptyset]], {}), { condition = in_mathzone }),
  s({ trig = 'ell', wordTrig = false, }, fmt([[\ell]], {}), { condition = in_mathzone }),
  s({ trig = 'times', wordTrig = false, }, fmt([[\times]], {}), { condition = in_mathzone }),
  s({ trig = 'therefore', wordTrig = false, }, fmt([[\therefore]], {}), { condition = in_mathzone }),
  s({ trig = 'alpha', wordTrig = false, }, fmt([[\alpha]], {}), { condition = in_mathzone }),
  s({ trig = 'Alpha', wordTrig = false, }, fmt([[\Alpha]], {}), { condition = in_mathzone }),
  s({ trig = 'beta', wordTrig = false, }, fmt([[\beta]], {}), { condition = in_mathzone }),
  s({ trig = 'Beta', wordTrig = false, }, fmt([[\Beta]], {}), { condition = in_mathzone }),
  s({ trig = 'gamma', wordTrig = false, }, fmt([[\gamma]], {}), { condition = in_mathzone }),
  s({ trig = 'Gamma', wordTrig = false, }, fmt([[\Gamma]], {}), { condition = in_mathzone }),
  s({ trig = 'delta', wordTrig = false, }, fmt([[\delta]], {}), { condition = in_mathzone }),
  s({ trig = 'Delta', wordTrig = false, }, fmt([[\Delta]], {}), { condition = in_mathzone }),
  s({ trig = 'epsilon', wordTrig = false, }, fmt([[\epsilon]], {}), { condition = in_mathzone }),
  s({ trig = 'Epsilon', wordTrig = false, }, fmt([[\Epsilon]], {}), { condition = in_mathzone }),
  s({ trig = 'zeta', wordTrig = false, }, fmt([[\zeta]], {}), { condition = in_mathzone }),
  s({ trig = 'Zeta', wordTrig = false, }, fmt([[\Zeta]], {}), { condition = in_mathzone }),
  s({ trig = 'eta', wordTrig = false, }, fmt([[\eta]], {}), { condition = in_mathzone }),
  s({ trig = 'Eta', wordTrig = false, }, fmt([[\Eta]], {}), { condition = in_mathzone }),
  s({ trig = 'theta', wordTrig = false, }, fmt([[\theta]], {}), { condition = in_mathzone }),
  s({ trig = 'Theta', wordTrig = false, }, fmt([[\Theta]], {}), { condition = in_mathzone }),
  s({ trig = 'iota', wordTrig = false, }, fmt([[\iota]], {}), { condition = in_mathzone }),
  s({ trig = 'Iota', wordTrig = false, }, fmt([[\Iota]], {}), { condition = in_mathzone }),
  s({ trig = 'kappa', wordTrig = false, }, fmt([[\kappa]], {}), { condition = in_mathzone }),
  s({ trig = 'Kappa', wordTrig = false, }, fmt([[\Kappa]], {}), { condition = in_mathzone }),
  s({ trig = 'lambda', wordTrig = false, }, fmt([[\lambda]], {}), { condition = in_mathzone }),
  s({ trig = 'Lambda', wordTrig = false, }, fmt([[\Lambda]], {}), { condition = in_mathzone }),
  s({ trig = 'mu', wordTrig = false, }, fmt([[\mu]], {}), { condition = in_mathzone }),
  s({ trig = 'Mu', wordTrig = false, }, fmt([[\Mu]], {}), { condition = in_mathzone }),
  s({ trig = 'nu', wordTrig = false, }, fmt([[\nu]], {}), { condition = in_mathzone }),
  s({ trig = 'Nu', wordTrig = false, }, fmt([[\Nu]], {}), { condition = in_mathzone }),
  s({ trig = 'xi', wordTrig = false, }, fmt([[\xi]], {}), { condition = in_mathzone }),
  s({ trig = 'Xi', wordTrig = false, }, fmt([[\Xi]], {}), { condition = in_mathzone }),
  s({ trig = 'omicron', wordTrig = false, }, fmt([[\omicron]], {}), { condition = in_mathzone }),
  s({ trig = 'Omicron', wordTrig = false, }, fmt([[\Omicron]], {}), { condition = in_mathzone }),
  s({ trig = 'pi', wordTrig = false, }, fmt([[\pi]], {}), { condition = in_mathzone }),
  s({ trig = 'Pi', wordTrig = false, }, fmt([[\Pi]], {}), { condition = in_mathzone }),
  s({ trig = 'rho', wordTrig = false, }, fmt([[\rho]], {}), { condition = in_mathzone }),
  s({ trig = 'Rho', wordTrig = false, }, fmt([[\Rho]], {}), { condition = in_mathzone }),
  s({ trig = 'sigma', wordTrig = false, }, fmt([[\sigma]], {}), { condition = in_mathzone }),
  s({ trig = 'Sigma', wordTrig = false, }, fmt([[\Sigma]], {}), { condition = in_mathzone }),
  s({ trig = 'tau', wordTrig = false, }, fmt([[\tau]], {}), { condition = in_mathzone }),
  s({ trig = 'Tau', wordTrig = false, }, fmt([[\Tau]], {}), { condition = in_mathzone }),
  s({ trig = 'upsilon', wordTrig = false, }, fmt([[\upsilon]], {}), { condition = in_mathzone }),
  s({ trig = 'Upsilon', wordTrig = false, }, fmt([[\Upsilon]], {}), { condition = in_mathzone }),
  s({ trig = 'phi', wordTrig = false, }, fmt([[\phi]], {}), { condition = in_mathzone }),
  s({ trig = 'Phi', wordTrig = false, }, fmt([[\Phi]], {}), { condition = in_mathzone }),
  s({ trig = 'chi', wordTrig = false, }, fmt([[\chi]], {}), { condition = in_mathzone }),
  s({ trig = 'Chi', wordTrig = false, }, fmt([[\Chi]], {}), { condition = in_mathzone }),
  s({ trig = 'psi', wordTrig = false, }, fmt([[\psi]], {}), { condition = in_mathzone }),
  s({ trig = 'Psi', wordTrig = false, }, fmt([[\Psi]], {}), { condition = in_mathzone }),
  s({ trig = 'omega', wordTrig = false, }, fmt([[\omega]], {}), { condition = in_mathzone }),
  s({ trig = 'Omega', wordTrig = false, }, fmt([[\Omega]], {}), { condition = in_mathzone }),
  s({ trig = 'ddx', wordTrig = false, }, fmt([[\frac{{\mathrm{{d{1}}}}}{{\mathrm{{d{2}}}}}]], { i(1, 'V'), i(2, 'x') }),
    { condition = in_mathzone }),
  s({ trig = 'sum', wordTrig = false, }, fmt([[\sum_{{n={1}}}^{{{2}}}]], { i(1, '1'), i(2, [[\infty]]) }),
    { condition = in_mathzone }),
  s({ trig = 'prod', wordTrig = false, }, fmt([[\prod_{{n={1}}}^{{{2}}}]], { i(1, '1'), i(2, [[\infty]]) }),
    { condition = in_mathzone }),
  s({ trig = 'partial', wordTrig = false, }, fmt([[\frac{{\partial {1}}}{{\partial {2}}}]], { i(1, 'V'), i(2, 'x') }),
    { condition = in_mathzone }),
  s({ trig = 'lim', wordTrig = false, }, fmt([[\lim_{{{1} \to {2}}}]], { i(1, 'n'), i(2, [[\infty]]) }),
    { condition = in_mathzone }),
  s(
    {
      trig = "(%a)bar",
      wordTrig = false,
      regTrig = true,
      priority = 100,
    },
    f(function(_, snip)
      return string.format("\\overline{%s}", snip.capturesh1h)
    end, {})
  ),
  s(
    {
      trig = "(%a)hat",
      wordTrig = false,
      regTrig = true,
      priority = 100,
    },
    f(function(_, snip)
      return string.format("\\hat{%s}", snip.captures[1])
    end, {})
  ),
  s({ trig = 'sin', wordTrig = false, }, fmt([[\sin]], {}), { condition = in_mathzone }),
  s({ trig = 'cos', wordTrig = false, }, fmt([[\cos]], {}), { condition = in_mathzone }),
  s({ trig = 'tan', wordTrig = false, }, fmt([[\tan]], {}), { condition = in_mathzone }),
  s({ trig = 'asin', wordTrig = false, }, fmt([[\arcsin]], {}), { condition = in_mathzone }),
  s({ trig = 'acos', wordTrig = false, }, fmt([[\arccos]], {}), { condition = in_mathzone }),
  s({ trig = 'atan', wordTrig = false, }, fmt([[\arctan]], {}), { condition = in_mathzone }),
  s({ trig = 'csc', wordTrig = false, }, fmt([[\csc]], {}), { condition = in_mathzone }),
  s({ trig = 'sec', wordTrig = false, }, fmt([[\sec]], {}), { condition = in_mathzone }),
  s({ trig = 'cot', wordTrig = false, }, fmt([[\cot]], {}), { condition = in_mathzone }),
  s({ trig = 'ln', wordTrig = false, }, fmt([[\ln]], {}), { condition = in_mathzone }),
  s({ trig = 'log', wordTrig = false, }, fmt([[\log]], {}), { condition = in_mathzone }),
  s({ trig = 'exp', wordTrig = false, }, fmt([[\exp]], {}), { condition = in_mathzone }),
  s({ trig = 'star', wordTrig = false, }, fmt([[\star]], {}), { condition = in_mathzone }),
  s({ trig = 'perp', wordTrig = false, }, fmt([[\perp]], {}), { condition = in_mathzone }),
  s({ trig = 'int', wordTrig = false, }, fmt([[\int]], {}), { condition = in_mathzone }),
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
