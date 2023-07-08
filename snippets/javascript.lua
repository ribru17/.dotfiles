---@diagnostic disable: undefined-global
return {
  s(
    {
      trig = 'log',
      name = 'Logging shortcut',
      dscr = 'Logs text to the console.',
    },
    fmt(
      [[console.log({1})]],
      { i(1, '') }
    ),
    {}
  ),
}
