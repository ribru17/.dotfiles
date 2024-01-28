-- format query files, aligning with nvim-treesitter standards
local format_buf = require('rileybruins.utils').format_query_buf
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(ev)
    format_buf(ev.buf)
  end,
  buffer = 0,
})
