---@diagnostic disable: undefined-global
return {
  s({
    trig = 'inject',
    name = 'Arbitrary Lua string injection',
    dscr = 'Injects the specified parser into the following string value.',
  }, fmt([[--> INJECT: {1}]], { i(1, 'parser') }), {}),
}
