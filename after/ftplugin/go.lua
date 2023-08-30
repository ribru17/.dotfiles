require('nvim-surround').buffer_setup {
  surrounds = {
    ['g'] = {
      add = function()
        local result = require('nvim-surround.config').get_input(
          'Enter the generic name: ')
        return {
          { result .. '[' },
          { ']' },
        }
      end,
      find = '[%w_]-%[.-%]',
      delete = '^([%w_]-%[)().-(%])()$',
    },
  },

}
