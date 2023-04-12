---@diagnostic disable: undefined-global

local function linestart(line_to_cursor)
  return string.find('!', line_to_cursor) == 1
end

local function no()
  return false
end

--> NOTE: VERY ODD BEHAVIOR FOR NON-AUTO SNIPPETS! <--
--> `condition` IS BUGGED. NO MATTER WHAT, SNIPPET CAN BE EXECUTED SO LONG AS
--> `show_condition` IS TRUE. IF `condition` SUPERCEDES `show_condition`, THE
--> SNIPPET CAN STILL EXPAND BUT WILL NOT SHOW UP IN THE CMP MENU.
return {
  s({
    trig = "!",
    name = "Emmet HTML5 Boilerplate",
    dscr = "Creates a barebones HTML5 application.",
    condition = no,
    show_condition = linestart,
  }, fmt([[
            <!DOCTYPE html>
            <html lang="en">
            <head>
              <meta charset="UTF-8">
              <meta http-equiv="X-UA-Compatible" content="IE=edge">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>{1}</title>
            </head>
            <body>
              {2}
            </body>
            </html>
            ]],
    {
      i(1, 'Document'),
      i(2, ''),
    }), {}),
}, {
}
