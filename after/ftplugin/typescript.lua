require('nvim-surround').buffer_setup {
  surrounds = {
    F = {
      add = function()
        local result = require('nvim-surround.config').get_input(
          'Enter the function name: ')
        if result then
          result = result == '' and result or 'const ' .. result .. ' = '
        end
        return {
          { result .. '() => {' },
          { '}' },
        }
      end,
      find = '%(%) => {.-}',
      delete = '^(%(%) => {)().-(})()$',
    },
  },
}
