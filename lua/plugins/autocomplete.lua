return {
  {
    'windwp/nvim-autopairs',
    lazy = true,
    config = function()
      local npairs = require 'nvim-autopairs'
      npairs.setup {}
      local Rule = require 'nvim-autopairs.rule'
      local cond = require 'nvim-autopairs.conds'

      -- rule for: `(|)` -> Space -> `( | )` and associated deletion options
      local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
      npairs.add_rules {
        Rule(' ', ' ')
            :with_pair(function(opts)
              local pair = opts.line:sub(opts.col - 1, opts.col)
              return vim.tbl_contains({
                brackets[1][1] .. brackets[1][2],
                brackets[2][1] .. brackets[2][2],
                brackets[3][1] .. brackets[3][2],
              }, pair)
            end),
      }

      for _, bracket in pairs(brackets) do
        npairs.add_rules {
          -- add move for brackets with pair of spaces inside
          Rule(bracket[1] .. ' ', ' ' .. bracket[2])
              :with_pair(function() return false end)
              :with_del(function() return false end)
              :with_move(function(opts)
                return opts.prev_char:match('.%' .. bracket[2]) ~= nil
              end)
              :use_key(bracket[2]),

          -- add closing brackets even if next char is '$'
          Rule(bracket[1], bracket[2])
              :with_pair(cond.after_text('$')),

          Rule(bracket[1] .. bracket[2], '')
              :with_pair(function() return false end),
        }
      end

      -- add and delete pairs of dollar signs (if not escaped) in markdown
      npairs.add_rule(
        Rule('$', '$', 'markdown')
        :with_move(function(opts)
          return opts.next_char == opts.char
        end)
        :with_pair(cond.not_before_text('\\'))
      )

      -- automatically add brackets for arrow functions
      npairs.add_rule(
        Rule('%(.*%)%s*%=>$', ' {  }',
          { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' })
        :use_regex(true, '>')
        :set_end_pair_length(2)
      )

      npairs.add_rule(
        Rule('/**', '  */')
        :with_pair(cond.not_after_regex('.-%*/', -1))
        :set_end_pair_length(3)
      )

      npairs.add_rule(
        Rule('**', '**', 'markdown')
        :with_move(cond.after_text('*'))
      )
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    config = function()
      local ls = require('luasnip')
      ls.config.set_config {
        enable_autosnippets = true,
        history = true,
      }
      require('luasnip.loaders.from_lua').lazy_load { paths = './snippets' }

      -- allow ts-autotag to coexist with luasnip
      local autotag = require('nvim-ts-autotag.internal')
      vim.keymap.set('i', '>', function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { '>' })
        autotag.close_tag()
        vim.api.nvim_win_set_cursor(0, { row, col + 1 })
        ls.expand_auto()
      end, { remap = false })
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'onsails/lspkind-nvim' },
    },
    config = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
            vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col)
            :match('%s') == nil
      end

      local escape_next = function()
        local current_line = vim.api.nvim_get_current_line()
        local _, col = unpack(vim.api.nvim_win_get_cursor(0))
        local next_char = string.sub(current_line, col + 1, col + 1)
        return next_char == ')' or next_char == '"' or next_char == "'" or
            next_char == '`' or next_char == ']' or next_char == '}'
      end

      local move_right = function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_win_set_cursor(0, { row, col + 1 })
      end

      local try_bullet_tab = function()
        local line = vim.api.nvim_get_current_line()
        return line:match('^%s*(.-)%s*$') == '-' and
            vim.bo.filetype == 'markdown'
      end
      -- supertab functionality
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local luasnip = require('luasnip')
      local cmp_mappings = {
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm { select = true }
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif escape_next() then
            move_right()
          elseif try_bullet_tab() then
            vim.cmd [[BulletDemote]]
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            vim.api.nvim_win_set_cursor(0, { row, col + 1 })
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          elseif try_bullet_tab() then
            vim.cmd [[BulletPromote]]
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            vim.api.nvim_win_set_cursor(0, { row, col + 1 })
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping(function(fallback)
          fallback()
        end),
      }

      local cmp_config = {
        mapping = cmp_mappings,
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = {
          { name = 'path' },
          { name = 'nvim_lua', ft = 'lua' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer',   keyword_length = 3 },
        },
        formatting = {
          fields = { 'abbr', 'menu', 'kind' },
          format = lspkind.cmp_format {
            mode = 'symbol_text', -- show only symbol annotations
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(_, vim_item)
              -- set fixed width of cmp window
              local min_width = 30
              local max_width = 30
              local ellipses_char = '…'
              local label = vim_item.abbr
              local truncated_label = vim.fn.strcharpart(label, 0, max_width)
              if truncated_label ~= label then
                vim_item.abbr = truncated_label .. ellipses_char
              elseif string.len(label) < min_width then
                local padding = string.rep(' ', min_width - string.len(label))
                vim_item.abbr = label .. padding
              end
              return vim_item
            end,
          },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = true,
        },
      }

      -- Insert `(` after select function or method item
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )

      cmp.setup(cmp_config)
    end,
  },
}
