---@diagnostic disable-next-line: missing-fields
require('nvim-surround').buffer_setup {
  surrounds = {
    ---@diagnostic disable-next-line: missing-fields
    F = {
      add = function()
        local result =
          require('nvim-surround.config').get_input('Enter the function name: ')
        if result then
          result = result == '' and 'function' or 'local function ' .. result
          return {
            { result .. '() ' },
            { ' end' },
          }
        end
      end,
      find = function()
        return require('nvim-surround.config').get_selection {
          query = { capture = '@function.outer', type = 'textobjects' },
        }
      end,
      --> INJECT: luap
      delete = '^(.-function.-%(.-%))().-(end)()$',
    },
  },
}
