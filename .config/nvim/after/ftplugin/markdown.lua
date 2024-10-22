vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'nc'
-- Allow block comments to be continued when hitting enter.
vim.opt_local.formatoptions:append('qcro')
vim.b.matchup_matchparen_enabled = false

-- Allow bullets.vim and nvim-autopairs to coexist.
vim.schedule(function()
  vim.keymap.set('i', '<CR>', function()
    local pair = require('nvim-autopairs').completion_confirm()
    if
      vim.bo.ft == 'markdown'
      and pair == vim.api.nvim_replace_termcodes('<CR>', true, false, true)
    then
      vim.cmd.InsertNewBullet()
    else
      vim.api.nvim_feedkeys(pair, 'n', false)
    end
  end, {
    buffer = 0,
  })
end)

local config = require('nvim-surround.config')
local in_latex_zone = require('rileybruins.utils').in_latex_zone
---@diagnostic disable-next-line: missing-fields
require('nvim-surround').buffer_setup {
  aliases = {
    ['b'] = { '{', '[', '(', '<', 'b' },
  },
  surrounds = {
    ---@diagnostic disable-next-line: missing-fields
    ['b'] = {
      add = { '**', '**' },
      --> INJECT: luap
      find = '%*%*.-%*%*',
      --> INJECT: luap
      delete = '^(%*%*)().-(%*%*)()$',
    },
    -- recognize latex-style functions when in latex snippets
    ['f'] = {
      add = function()
        local result = config.get_input('Enter the function name: ')
        if result then
          if in_latex_zone() then
            return { { '\\' .. result .. '{' }, { '}' } }
          end
          return { { result .. '(' }, { ')' } }
        end
      end,
      find = function()
        if in_latex_zone() then
          return config.get_selection {
            --> INJECT: luap
            pattern = '\\[%w_]+{.-}',
          }
        end
        if vim.g.loaded_nvim_treesitter then
          local selection = config.get_selection {
            query = { capture = '@call.outer', type = 'textobjects' },
          }
          if selection then
            return selection
          end
        end
        return config.get_selection {
          --> INJECT: luap
          pattern = '[^=%s%(%){}]+%b()',
        }
      end,
      ---@param char string
      delete = function(char)
        local match
        if in_latex_zone() then
          match = config.get_selections {
            char = char,
            --> INJECT: luap
            pattern = '^(\\[%w_]+{)().-(})()$',
          }
        else
          match = config.get_selections {
            char = char,
            --> INJECT: luap
            pattern = '^(.-%()().-(%))()$',
          }
        end
        return match
      end,
      change = {
        ---@param char string
        target = function(char)
          if in_latex_zone() then
            return config.get_selections {
              char = char,
              --> INJECT: luap
              pattern = '^.-\\([%w_]+)(){.-}()()$',
            }
          else
            return config.get_selections {
              char = char,
              --> INJECT: luap
              pattern = '^.-([%w_]+)()%(.-%)()()$',
            }
          end
        end,
        replacement = function()
          local result = config.get_input('Enter the function name: ')
          if result then
            return { { result }, { '' } }
          end
        end,
      },
    },
  },
}
