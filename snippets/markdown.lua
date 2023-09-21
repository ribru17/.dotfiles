---@diagnostic disable: undefined-global
local get_node = vim.treesitter.get_node

local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
  math_environment = true,
}

local in_mathzone = function()
  -- redraw to make function wait for the main thread to finish tree-sitter parsing
  vim.cmd.redraw()
  local current_node = get_node { ignore_injections = false }
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

local in_text = function()
  return not in_mathzone()
end

local frac_no_parens = {
  f(function(_, snip)
    return string.format('\\frac{%s}', snip.captures[1])
  end, {}),
  t('{'),
  i(1),
  t('}'),
  i(0),
}

local frac = s({
  priority = 1000,
  trig = '.*%)/',
  wordTrig = true,
  regTrig = true,
  condition = in_mathzone,
}, {
  f(function(_, snip)
    local match = snip.trigger
    local stripped = match:sub(1, #match - 1)

    local k = #stripped
    local depth = 0
    while true do
      if stripped:sub(k, k) == ')' then
        depth = depth + 1
      end
      if stripped:sub(k, k) == '(' then
        depth = depth - 1
      end
      if depth == 0 then
        break
      end
      k = k - 1
    end

    local rv = string.format(
      '%s\\frac{%s}',
      stripped:sub(1, k - 1),
      stripped:sub(k + 1, #stripped - 1)
    )

    return rv
  end, {}),
  t('{'),
  i(1),
  t('}'),
  i(0),
})

return {
  --->> NO AUTO-EXPAND <<---

  s(
    {
      trig = 'flowchart',
      name = 'Mermaid Flowchart',
      dscr = 'Generates a basic left-to-right Mermaid flowchart.',
    },
    fmt(
      [[
  ```mermaid
  flowchart LR

  A({1}) --> B({2}){3}
  ```
  ]],
      { i(1, 'Start'), i(2, 'End'), i(3, '') }
    ),
    {
      condition = function()
        return false
      end,
      show_condition = in_text,
    }
  ),
  s({ trig = 'tbl(%d+)x(%d+)', regTrig = true }, {
    d(1, function(_, snip)
      local nodes = {}
      local i_counter = 0
      local hlines = ''
      for _ = 1, snip.captures[2] do
        i_counter = i_counter + 1
        table.insert(nodes, t('| '))
        table.insert(nodes, i(i_counter, 'Column_' .. i_counter))
        table.insert(nodes, t(' '))
        hlines = hlines .. '| -------- '
      end
      table.insert(nodes, t { '|', '' })
      hlines = hlines .. '|'
      table.insert(nodes, t { hlines, '' })
      for c_i = 1, snip.captures[1] do
        for c_j = 1, snip.captures[2] do
          i_counter = i_counter + 1
          table.insert(nodes, t('| '))
          table.insert(nodes, i(i_counter, 'Cell_' .. c_i .. '_' .. c_j))
          table.insert(nodes, t(' '))
        end
        table.insert(nodes, t { '|', '' })
      end
      return sn(nil, nodes)
    end),
  }),
  s(
    {
      trig = 'lorem',
      name = 'Lorem Ipsum Text',
      dscr = 'Generates a long lorem ipsum text.',
    },
    fmt(
      [[Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Aliquet nec ullamcorper sit amet. Volutpat diam ut venenatis tellus in. Egestas sed sed risus pretium quam vulputate dignissim suspendisse. Sapien pellentesque habitant morbi tristique senectus et netus et malesuada. Eu feugiat pretium nibh ipsum. Convallis aenean et tortor at risus viverra. Libero volutpat sed cras ornare arcu. Pharetra vel turpis nunc eget lorem dolor sed viverra. Lacus laoreet non curabitur gravida arcu ac tortor dignissim. Ut eu sem integer vitae justo eget magna fermentum. Leo duis ut diam quam nulla porttitor massa id. Purus sit amet volutpat consequat mauris nunc congue. Eget lorem dolor sed viverra ipsum nunc aliquet bibendum. Cursus risus at ultrices mi.]],
      {}
    ),
    {}
  ),
}, {
  --->> AUTO-EXPAND <<---

  --> IN MATH ZONE, NO WORD BOUNDARY
  s(
    { trig = '*', wordTrig = false },
    fmt([[\cdot]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'ast', wordTrig = false },
    fmt([[\ast]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '^', wordTrig = false },
    fmt([[^{{{1}}}]], { i(1, '') }),
    { condition = in_mathzone }
  ),
  s(
    { trig = '<=', wordTrig = false },
    fmt([[\le]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '>=', wordTrig = false },
    fmt([[\ge]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '~~', wordTrig = false },
    fmt([[\approx]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '=>', wordTrig = false },
    fmt([[\Rightarrow]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '==>', wordTrig = false, priority = 1001 },
    fmt([[\implies]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '->', wordTrig = false },
    fmt([[\longrightarrow]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '=<', wordTrig = false },
    fmt([[\impliedby]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '>>', wordTrig = false },
    fmt([[\gg]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '<<', wordTrig = false },
    fmt([[\ll]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '!=', wordTrig = false },
    fmt([[\neq]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'nabla', wordTrig = false },
    fmt([[\nabla]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '//', wordTrig = false },
    fmt([[\frac{{{1}}}{{{2}}}]], { i(1, 'a'), i(2, 'b') }),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'EE', wordTrig = false },
    fmt([[\exists]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'exists', wordTrig = false },
    fmt([[\exists]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'AA', wordTrig = false },
    fmt([[\forall]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'forall', wordTrig = false },
    fmt([[\forall]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'notin', wordTrig = false },
    fmt([[\not\in]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'cc', wordTrig = false },
    fmt([[\subset]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '<->', wordTrig = false },
    fmt([[\leftrightarrow]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '...', wordTrig = false },
    fmt([[\ldots]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'iff', wordTrig = false },
    fmt([[\iff]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '\\le>', wordTrig = false },
    fmt([[\Leftrightarrow]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '\\le=>', wordTrig = false, priority = 1001 },
    fmt([[\iff]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'to', wordTrig = false },
    fmt([[\to]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '|', wordTrig = false },
    fmt([[\mid]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'sqrt', wordTrig = false },
    fmt([[\sqrt{{{1}}}]], { i(1, '') }),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'inf', wordTrig = false },
    fmt([[\infty]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = '<>', wordTrig = false },
    fmt([[\diamond]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'xnn', wordTrig = false },
    t([[x_{n}]]),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'ynn', wordTrig = false },
    t([[y_{n}]]),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'xii', wordTrig = false },
    t([[x_{i}]]),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'yii', wordTrig = false },
    t([[y_{i}]]),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'xjj', wordTrig = false },
    t([[x_{j}]]),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'yjj', wordTrig = false },
    t([[y_{j}]]),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'xp1', wordTrig = false },
    t([[x_{n+1}]]),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'xmm', wordTrig = false },
    t([[x_{m}]]),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'dint', wordTrig = false },
    fmt([[\int_{{{1}}}^{{{2}}}]], { i(1, [[-\infty]]), i(2, [[\infty]]) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'ceil', wordTrig = false },
    fmt([[\lceil {1}\rceil]], { i(1, '') }),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'floor', wordTrig = false },
    fmt([[\lfloor {1}\rfloor]], { i(1, '') }),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'RR', wordTrig = false },
    fmt([[\mathbb{{R}}]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'ZZ', wordTrig = false },
    fmt([[\mathbb{{Z}}]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'QQ', wordTrig = false },
    fmt([[\mathbb{{Q}}]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'NN', wordTrig = false },
    fmt([[\mathbb{{N}}]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'DD', wordTrig = false },
    fmt([[\mathbb{{D}}]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'HH', wordTrig = false },
    fmt([[\mathbb{{H}}]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'WW', wordTrig = false },
    fmt([[\mathbb{{W}}]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'nn', wordTrig = false },
    fmt([[\cap]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'uu', wordTrig = false },
    fmt([[\cup]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'empty', wordTrig = false },
    fmt([[\emptyset]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'ell', wordTrig = false },
    fmt([[\ell]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'times', wordTrig = false },
    fmt([[\times]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'therefore', wordTrig = false },
    fmt([[\therefore]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'ddx', wordTrig = false },
    fmt(
      [[\frac{{\mathrm{{d{1}}}}}{{\mathrm{{d{2}}}}}]],
      { i(1, 'V'), i(2, 'x') }
    ),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'sum', wordTrig = false },
    fmt([[\sum_{{n={1}}}^{{{2}}}]], { i(1, '1'), i(2, [[\infty]]) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'prod', wordTrig = false },
    fmt([[\prod_{{n={1}}}^{{{2}}}]], { i(1, '1'), i(2, [[\infty]]) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'partial', wordTrig = false },
    fmt([[\frac{{\partial {1}}}{{\partial {2}}}]], { i(1, 'V'), i(2, 'x') }),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'lim', wordTrig = false },
    fmt([[\lim_{{{1} \to {2}}}]], { i(1, 'n'), i(2, [[\infty]]) }),
    { condition = in_mathzone }
  ),
  s(
    {
      trig = '(%a)bar',
      wordTrig = false,
      regTrig = true,
      priority = 100,
    },
    f(function(_, snip)
      return string.format('\\overline{%s}', snip.captures[1])
    end, {}),
    { condition = in_mathzone }
  ),
  s(
    {
      trig = '(%a)hat',
      wordTrig = false,
      regTrig = true,
      priority = 100,
    },
    f(function(_, snip)
      return string.format('\\hat{%s}', snip.captures[1])
    end, {}),
    { condition = in_mathzone }
  ),
  s(
    {
      trig = '([%a0])vec',
      wordTrig = false,
      regTrig = true,
      priority = 100,
    },
    f(function(_, snip)
      return string.format('\\vec{%s}', snip.captures[1])
    end, {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'sin', wordTrig = false },
    fmt([[\sin]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'cos', wordTrig = false },
    fmt([[\cos]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'tan', wordTrig = false },
    fmt([[\tan]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'asin', wordTrig = false },
    fmt([[\arcsin]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'acos', wordTrig = false },
    fmt([[\arccos]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'atan', wordTrig = false },
    fmt([[\arctan]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'csc', wordTrig = false },
    fmt([[\csc]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'sec', wordTrig = false },
    fmt([[\sec]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'cot', wordTrig = false },
    fmt([[\cot]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'ln', wordTrig = false },
    fmt([[\ln]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'log', wordTrig = false },
    fmt([[\log]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'exp', wordTrig = false },
    fmt([[\exp]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'star', wordTrig = false },
    fmt([[\star]], {}),
    { condition = in_mathzone }
  ),
  s(
    { trig = 'perp', wordTrig = false },
    fmt([[\perp]], {}),
    { condition = in_mathzone }
  ),

  --> IN MATH ZONE, WORD BOUNDARY

  frac,
  s({
    trig = '([%a])(%d)',
    regTrig = true,
    condition = in_mathzone,
  }, {
    f(function(_, snip)
      return string.format('%s_%s', snip.captures[1], snip.captures[2])
    end, {}),
    i(0),
  }),

  s({
    trig = '([%a])_(%d%d)',
    regTrig = true,
    condition = in_mathzone,
  }, {
    f(function(_, snip)
      return string.format('%s_{%s}', snip.captures[1], snip.captures[2])
    end, {}),
    i(0),
  }),

  s({
    trig = '(\\?[%w]+\\?^%w)/',
    regTrig = true,
    condition = in_mathzone,
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = '(\\?[%w]+\\?_%w)/',
    regTrig = true,
    condition = in_mathzone,
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = '(\\?[%w]+\\?^{%w*})/',
    regTrig = true,
    condition = in_mathzone,
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = '(\\?[%w]+\\?_{%w*})/',
    regTrig = true,
    condition = in_mathzone,
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = '(\\?%w+)/',
    regTrig = true,
    condition = in_mathzone,
  }, vim.deepcopy(frac_no_parens)),

  s({ trig = 'in' }, fmt([[\in]], {}), { condition = in_mathzone }),
  s({ trig = 'alpha' }, fmt([[\alpha]], {}), { condition = in_mathzone }),
  s({ trig = 'Alpha' }, fmt([[\Alpha]], {}), { condition = in_mathzone }),
  s({ trig = 'beta' }, fmt([[\beta]], {}), { condition = in_mathzone }),
  s({ trig = 'Beta' }, fmt([[\Beta]], {}), { condition = in_mathzone }),
  s({ trig = 'gamma' }, fmt([[\gamma]], {}), { condition = in_mathzone }),
  s({ trig = 'Gamma' }, fmt([[\Gamma]], {}), { condition = in_mathzone }),
  s({ trig = 'delta' }, fmt([[\delta]], {}), { condition = in_mathzone }),
  s({ trig = 'Delta' }, fmt([[\Delta]], {}), { condition = in_mathzone }),
  s({ trig = 'epsilon' }, fmt([[\epsilon]], {}), { condition = in_mathzone }),
  s({ trig = 'Epsilon' }, fmt([[\Epsilon]], {}), { condition = in_mathzone }),
  s({ trig = 'zeta' }, fmt([[\zeta]], {}), { condition = in_mathzone }),
  s({ trig = 'Zeta' }, fmt([[\Zeta]], {}), { condition = in_mathzone }),
  s({ trig = 'eta' }, fmt([[\eta]], {}), { condition = in_mathzone }),
  s({ trig = 'Eta' }, fmt([[\Eta]], {}), { condition = in_mathzone }),
  s({ trig = 'theta' }, fmt([[\theta]], {}), { condition = in_mathzone }),
  s({ trig = 'Theta' }, fmt([[\Theta]], {}), { condition = in_mathzone }),
  s({ trig = 'iota' }, fmt([[\iota]], {}), { condition = in_mathzone }),
  s({ trig = 'Iota' }, fmt([[\Iota]], {}), { condition = in_mathzone }),
  s({ trig = 'kappa' }, fmt([[\kappa]], {}), { condition = in_mathzone }),
  s({ trig = 'Kappa' }, fmt([[\Kappa]], {}), { condition = in_mathzone }),
  s({ trig = 'lambda' }, fmt([[\lambda]], {}), { condition = in_mathzone }),
  s({ trig = 'Lambda' }, fmt([[\Lambda]], {}), { condition = in_mathzone }),
  s({ trig = 'mu' }, fmt([[\mu]], {}), { condition = in_mathzone }),
  s({ trig = 'Mu' }, fmt([[\Mu]], {}), { condition = in_mathzone }),
  s({ trig = 'nu' }, fmt([[\nu]], {}), { condition = in_mathzone }),
  s({ trig = 'Nu' }, fmt([[\Nu]], {}), { condition = in_mathzone }),
  s({ trig = 'xi ' }, fmt([[\xi ]], {}), { condition = in_mathzone }),
  s({ trig = 'Xi ' }, fmt([[\Xi ]], {}), { condition = in_mathzone }),
  s({ trig = 'omicron' }, fmt([[\omicron]], {}), { condition = in_mathzone }),
  s({ trig = 'Omicron' }, fmt([[\Omicron]], {}), { condition = in_mathzone }),
  s({ trig = 'pi' }, fmt([[\pi]], {}), { condition = in_mathzone }),
  s({ trig = 'Pi' }, fmt([[\Pi]], {}), { condition = in_mathzone }),
  s({ trig = 'rho' }, fmt([[\rho]], {}), { condition = in_mathzone }),
  s({ trig = 'Rho' }, fmt([[\Rho]], {}), { condition = in_mathzone }),
  s({ trig = 'sigma' }, fmt([[\sigma]], {}), { condition = in_mathzone }),
  s({ trig = 'Sigma' }, fmt([[\Sigma]], {}), { condition = in_mathzone }),
  s({ trig = 'tau' }, fmt([[\tau]], {}), { condition = in_mathzone }),
  s({ trig = 'Tau' }, fmt([[\Tau]], {}), { condition = in_mathzone }),
  s({ trig = 'upsilon' }, fmt([[\upsilon]], {}), { condition = in_mathzone }),
  s({ trig = 'Upsilon' }, fmt([[\Upsilon]], {}), { condition = in_mathzone }),
  s({ trig = 'phi' }, fmt([[\phi]], {}), { condition = in_mathzone }),
  s({ trig = 'Phi' }, fmt([[\Phi]], {}), { condition = in_mathzone }),
  s({ trig = 'chi' }, fmt([[\chi]], {}), { condition = in_mathzone }),
  s({ trig = 'Chi' }, fmt([[\Chi]], {}), { condition = in_mathzone }),
  s({ trig = 'psi' }, fmt([[\psi]], {}), { condition = in_mathzone }),
  s({ trig = 'Psi' }, fmt([[\Psi]], {}), { condition = in_mathzone }),
  s({ trig = 'omega' }, fmt([[\omega]], {}), { condition = in_mathzone }),
  s({ trig = 'Omega' }, fmt([[\Omega]], {}), { condition = in_mathzone }),
  s({ trig = 'and' }, fmt([[\land]], {}), { condition = in_mathzone }),
  s({ trig = 'or' }, fmt([[\lor]], {}), { condition = in_mathzone }),
  s({ trig = 'not' }, fmt([[\lnot]], {}), { condition = in_mathzone }),
  s({ trig = 'xor' }, fmt([[\oplus]], {}), { condition = in_mathzone }),
  s({ trig = 'satisfies' }, fmt([[\vDash]], {}), { condition = in_mathzone }),
  s({ trig = 'entails' }, fmt([[\vDash]], {}), { condition = in_mathzone }),
  s({ trig = 'vDash' }, fmt([[\vDash]], {}), { condition = in_mathzone }),
  s({ trig = 'nvDash' }, fmt([[\nvDash]], {}), { condition = in_mathzone }),
  s({ trig = 'vdash' }, fmt([[\vdash]], {}), { condition = in_mathzone }),
  s({ trig = 'nvdash' }, fmt([[\nvdash]], {}), { condition = in_mathzone }),
  s({ trig = 'subseteq' }, fmt([[\subseteq]], {}), { condition = in_mathzone }),
  s({ trig = 'of' }, fmt([[\subseteq]], {}), { condition = in_mathzone }),
  s({ trig = 'implies' }, fmt([[\implies]], {}), { condition = in_mathzone }),
  s(
    { trig = 'text' },
    fmt([[\text{{{}}}]], { i(1, '') }),
    { condition = in_mathzone }
  ),

  --> NOT IN MATH ZONE <--

  s(
    { trig = 'dm' },
    fmt(
      [[
    $$
    {1}
    $$
    ]],
      { i(1, '') }
    ),
    { condition = in_text }
  ),
  s({ trig = 'mk' }, fmt([[${}$]], { i(1) }), { condition = in_text }),
}
