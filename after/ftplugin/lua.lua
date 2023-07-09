require('nvim-surround').buffer_setup {
  surrounds = {
    F = {
      add = function()
        local result = require('nvim-surround.config').get_input(
          'Enter the function name: ')
        if result then
          result = result == '' and 'function' or 'local function ' .. result
          return {
            { result .. '() ' },
            { ' end' },
          }
        end
      end,
      find = 'function.-%(%) .- end',
      delete = '^(function.-%(%) )().-( end)()$',
    },
  },
}
