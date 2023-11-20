vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'nc'
vim.opt_local.foldcolumn = '0'
-- Allow block comments to be continued when hitting enter.
vim.opt_local.formatoptions:append('qcro')
vim.b.matchup_matchparen_enabled = false

-- Allow bullets.vim and nvim-autopairs to coexist.
vim.schedule(function()
  vim.keymap.set('i', '<CR>', function()
    local pair = require('nvim-autopairs').completion_confirm()
    if pair == vim.api.nvim_replace_termcodes('<CR>', true, false, true) then
      vim.cmd.InsertNewBullet()
    else
      vim.api.nvim_feedkeys(pair, 'n', false)
    end
  end, {
    buffer = 0,
  })
end)

local config = require('nvim-surround.config')
local in_latex_zone = require('utils').in_latex_zone
require('nvim-surround').buffer_setup {
  aliases = {
    ['b'] = { '{', '[', '(', '<', 'b' },
  },
  surrounds = {
    ['b'] = {
      add = { '**', '**' },
      find = '%*%*.-%*%*',
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
          pattern = '[^=%s%(%){}]+%b()',
        }
      end,
      delete = function(char)
        local match
        if in_latex_zone() then
          match = config.get_selections {
            char = char,
            pattern = '^(\\[%w_]+{)().-(})()$',
          }
        else
          match = config.get_selections {
            char = char,
            pattern = '^(.-%()().-(%))()$',
          }
        end
        return match
      end,
      change = {
        target = function(char)
          if in_latex_zone() then
            return config.get_selections {
              char = char,
              pattern = '^.-\\([%w_]+)(){.-}()()$',
            }
          else
            return config.get_selections {
              char = char,
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
