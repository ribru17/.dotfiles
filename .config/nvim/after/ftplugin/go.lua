---@diagnostic disable-next-line: missing-fields
require('nvim-surround').buffer_setup {
  surrounds = {
    ---@diagnostic disable-next-line: missing-fields
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
      --> INJECT: luap
      find = '[%w_]-%[.-%]',
      --> INJECT: luap
      delete = '^([%w_]-%[)().-(%])()$',
    },
    ---@diagnostic disable-next-line: missing-fields
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
      --> INJECT: luap
      find = '[%w_]-%[.-%]',
      --> INJECT: luap
      delete = '^([%w_]-%[)().-(%])()$',
    },
  },
}
