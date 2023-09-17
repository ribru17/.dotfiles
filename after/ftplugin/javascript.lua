local config = require('nvim-surround.config')
require('nvim-surround').buffer_setup {
  surrounds = {
    F = {
      add = function()
        local result =
          require('nvim-surround.config').get_input('Enter the function name: ')
        if result then
          if result == '' then
            return {
              { '() => {' },
              { '}' },
            }
          else
            return {
              { 'function ' .. result .. '() {' },
              { '}' },
            }
          end
        end
      end,
      find = function()
        return require('nvim-surround.config').get_selection {
          query = { capture = '@function.outer', type = 'textobjects' },
        }
      end,
      delete = function(char)
        local match = config.get_selections {
          char = char,
          pattern = '^(function%s+[%w_]-%s-%(.-%).-{)().-(})()$',
        }
        if not match then
          match = config.get_selections {
            char = char,
            pattern = '^(%(.-%)%s-=>%s-{)().-(})()$',
          }
        end
        return match
      end,
    },
  },
}
