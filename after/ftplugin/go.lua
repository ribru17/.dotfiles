require('nvim-surround').buffer_setup {
  surrounds = {
    ['g'] = {
      add = function()
        local result =
          require('nvim-surround.config').get_input('Enter the generic name: ')
        if result then
          return {
            { result .. '[' },
            { ']' },
          }
        end
      end,
      find = '[%w_]-%[.-%]',
      delete = '^([%w_]-%[)().-(%])()$',
    },
    ['G'] = {
      add = function()
        local result =
          require('nvim-surround.config').get_input('Enter the generic name: ')
        if result then
          return {
            { result .. '[' },
            { ']' },
          }
        end
      end,
      find = '[%w_]-%[.-%]',
      delete = '^([%w_]-%[)().-(%])()$',
    },
  },
}
