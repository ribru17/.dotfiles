local config = require('nvim-surround.config')
require('nvim-surround').buffer_setup {
  surrounds = {
    F = {
      add = function()
        local result = require('nvim-surround.config').get_input(
          'Enter the function name: ')
        if result then
          result = result == '' and result or 'const ' .. result .. ' = '
          return {
            { result .. '() => {' },
            { '}' },
          }
        end
      end,
      find = function()
        -- check for both named and unnamed arrow functions
        local named_match = config.get_selection('const [%w_]- = %(%) => {.-}')
        if named_match then
          return named_match
        else
          return config.get_selection('%(%) => {.-}')
        end
      end,
      delete = function()
        local named_match = config.get_selection {
          pattern = 'const [%w_]- = %(%) => {',
        }
        if not named_match then
          named_match = config.get_selection {
            pattern = '%(%) => {',
          }
        end
        return {
          left = named_match,
          right = config.get_selection {
            pattern = '}',
          },
        }
      end,
    },
  },
}
