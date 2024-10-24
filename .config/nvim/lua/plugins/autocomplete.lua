return {
  {
    'windwp/nvim-ts-autotag',
    ft = {
      'html',
      'xml',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'svelte',
      'vue',
      'tsx',
      'jsx',
      'rescript',
      'php',
      'glimmer',
      'handlebars',
      'hbs',
      'markdown',
    },
    -- disabled here because I have it overridden somewhere else in order to
    -- achieve compatibility with luasnip
    opts = { enable_close_on_slash = false },
  },
  {
    -- NOTE: Maybe replace with ultimate-autopair after the following issue is
    -- fixed: https://github.com/altermo/ultimate-autopair.nvim/issues/5.
    'windwp/nvim-autopairs',
    lazy = true,
    config = function()
      local npairs = require('nvim-autopairs')
      npairs.setup {}
      local Rule = require('nvim-autopairs.rule')
      local cond = require('nvim-autopairs.conds')
      local ts_conds = require('nvim-autopairs.ts-conds')

      -- rule for: `(|)` -> Space -> `( | )` and associated deletion options
      local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
      npairs.add_rules {
        Rule(' ', ' ', '-markdown')
          :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2],
            }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          :with_del(function(opts)
            -- We only want to delete the pair of spaces when the cursor is as such: ( | )
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({
              brackets[1][1] .. '  ' .. brackets[1][2],
              brackets[2][1] .. '  ' .. brackets[2][2],
              brackets[3][1] .. '  ' .. brackets[3][2],
            }, context)
          end),
      }

      for _, bracket in pairs(brackets) do
        npairs.add_rules {
          -- add move for brackets with pair of spaces inside
          Rule(bracket[1] .. ' ', ' ' .. bracket[2])
            :with_pair(function()
              return false
            end)
            :with_del(function()
              return false
            end)
            :with_move(function(opts)
              return opts.prev_char:match('.%' .. bracket[2]) ~= nil
            end)
            :use_key(bracket[2]),

          -- add closing brackets even if next char is '$'
          Rule(bracket[1], bracket[2]):with_pair(cond.after_text('$')),

          -- `()|` -> <BS> -> `|`
          Rule(bracket[1] .. bracket[2], ''):with_pair(function()
            return false
          end):with_cr(function()
            return false
          end),
        }
      end

      -- add and delete pairs of dollar signs (if not escaped) in markdown
      npairs.add_rule(Rule('$', '$', 'markdown')
        :with_move(function(opts)
          return opts.next_char == opts.char
            and ts_conds.is_ts_node {
              'inline_formula',
              'displayed_equation',
              'math_environment',
            }(opts)
        end)
        :with_pair(ts_conds.is_not_ts_node {
          'inline_formula',
          'displayed_equation',
          'math_environment',
        })
        :with_pair(cond.not_before_text('\\')))

      npairs.add_rule(Rule('/**', '  */'):with_pair(cond.not_after_regex(
        --> INJECT: luap
        '.-%*/',
        -1
      )):set_end_pair_length(3))

      npairs.add_rule(Rule('**', '**', 'markdown'):with_move(function(opts)
        return cond.after_text('*')(opts) and cond.not_before_text('\\')(opts)
      end))
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    lazy = true,
    config = function()
      local ls = require('luasnip')
      ls.config.set_config {
        enable_autosnippets = true,
        history = true,
        updateevents = 'TextChanged,TextChangedI',
      }
      ls.filetype_extend('typescript', { 'javascript' })
      ls.filetype_extend('javascriptreact', { 'javascript' })
      ls.filetype_extend('typescriptreact', { 'javascript' })
      require('luasnip.loaders.from_lua').lazy_load { paths = { './snippets' } }

      -- allow ts-autotag to coexist with luasnip
      local autotag
      vim.keymap.set('i', '>', function()
        -- NOTE: this function makes it so that inserted `>` characters are not
        -- dot-repeatable...
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { '>' })
        if not autotag then
          autotag = require('nvim-ts-autotag.internal')
        end
        autotag.close_tag()
        vim.api.nvim_win_set_cursor(0, { row, col + 1 })
        ls.expand_auto()
      end, { remap = false })

      -- NOTE: Uncomment the following to achieve auto tag closing upon entering
      -- a slash character.
      -- vim.keymap.set('i', '/', function()
      --   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      --   vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { '/' })
      --   autotag.close_slash_tag()
      --   local new_row, new_col = unpack(vim.api.nvim_win_get_cursor(0))
      --   vim.api.nvim_win_set_cursor(0, { new_row, new_col + 1 })
      --   ls.expand_auto()
      -- end, { remap = false })
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'f3fora/cmp-spell' },
      { 'hrsh7th/cmp-cmdline' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'onsails/lspkind-nvim' },
    },
    config = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')

      local escape_next = function()
        local current_line = vim.api.nvim_get_current_line()
        local _, col = unpack(vim.api.nvim_win_get_cursor(0))
        local next_char = string.sub(current_line, col + 1, col + 1)
        return next_char == ')'
          or next_char == '"'
          or next_char == "'"
          or next_char == '`'
          or next_char == ']'
          or next_char == '}'
      end

      local move_right = function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_win_set_cursor(0, { row, col + 1 })
      end

      local is_in_bullet = function()
        local line = vim.api.nvim_get_current_line()
        return line:match('^%s*(.-)%s*$') == '-'
          and (vim.bo.filetype == 'markdown' or vim.bo.filetype == 'text')
      end

      -- supertab functionality
      local luasnip = require('luasnip')
      local function ins_tab_mapping(fallback)
        local entry = cmp.get_selected_entry()
        if
          cmp.visible()
          -- if tabbing on an entry that already matches what we have, just
          -- skip and fall through to the next action
          and not (
            entry.source.name == 'spell'
            and entry.context.cursor_before_line:match(
              '^' .. entry:get_word() .. '$'
            )
          )
        then
          cmp.confirm { select = true }
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif escape_next() then
          move_right()
        elseif is_in_bullet() then
          vim.cmd.BulletDemote()
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          vim.api.nvim_win_set_cursor(0, { row, col + 1 })
        else
          fallback()
        end
      end

      local function ins_s_tab_mapping(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        elseif cmp.visible() then
          cmp.select_prev_item()
        elseif is_in_bullet() then
          vim.cmd.BulletPromote()
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          vim.api.nvim_win_set_cursor(0, { row, col + 1 })
        else
          fallback()
        end
      end

      local cmp_mappings = {
        ['<C-p>'] = {
          i = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
          },
          c = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Insert,
          },
        },
        ['<C-n>'] = {
          i = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
          },
          c = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Insert,
          },
        },
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
        ['<Tab>'] = {
          i = ins_tab_mapping,
          s = ins_tab_mapping,
          c = function()
            if cmp.visible() then
              cmp.confirm { select = true }
            else
              cmp.complete()
              cmp.select_next_item()
              cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
            end
          end,
        },
        ['<S-Tab>'] = {
          i = ins_s_tab_mapping,
          s = ins_s_tab_mapping,
          c = function()
            if cmp.visible() then
              cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
            else
              cmp.complete()
            end
          end,
        },
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      }

      local BORDER_STYLE = require('rileybruins.settings').border
      local in_ts_cap = require('cmp.config.context').in_treesitter_capture
      local in_jsx = require('rileybruins.utils').in_jsx_tags
      local kinds = require('cmp.types').lsp.CompletionItemKind
      local compare = require('cmp.config.compare')

      local cmp_info_style = cmp.config.window.bordered {
        border = BORDER_STYLE,
      }
      -- pumheight doesn't affect the documentation window
      cmp_info_style.max_height = 16

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
          {
            name = 'nvim_lsp',
            entry_filter = function(entry, _)
              -- filter out most text entries from LSP suggestions
              local keep_text_entries = { 'emmet_language_server', 'marksman' }
              local client_name = entry.source.source.client
                  and entry.source.source.client.name
                or ''
              local ft = vim.bo.filetype
              if
                client_name == 'emmet_language_server'
                and (ft == 'javascriptreact' or ft == 'typescriptreact')
              then
                return in_jsx(true)
              end
              return kinds[entry:get_kind()] ~= 'Text'
                or vim.tbl_contains(keep_text_entries, client_name)
            end,
          },
          { name = 'luasnip' },
          {
            name = 'spell',
            keyword_length = 3,
            -- help filter out the unhelpful words
            max_item_count = 1,
            entry_filter = function(entry, _)
              return not entry:get_completion_item().label:find(' ')
            end,
            option = {
              keep_all_entries = true,
              enable_in_context = function()
                return not in_ts_cap('nospell')
              end,
            },
          },
        },
        formatting = {
          fields = { 'abbr', 'menu', 'kind' },
          format = lspkind.cmp_format {
            mode = 'symbol_text',
            -- The function below will be called before any actual modifications
            -- from lspkind so that you can provide more controls on popup
            -- customization.
            -- (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(_, vim_item)
              -- set max width of cmp window
              local width = 30
              local ellipses_char = '…'
              local label = vim_item.abbr
              local truncated_label = vim.fn.strcharpart(label, 0, width)
              if truncated_label ~= label then
                vim_item.abbr = truncated_label .. ellipses_char
              else
                vim_item.abbr = label .. ' '
              end
              return vim_item
            end,
            menu = {
              spell = '[Dict]',
              nvim_lsp = '[LSP]',
              path = '[Path]',
              luasnip = '[Snip]',
            },
          },
        },
        window = {
          completion = cmp_info_style,
          documentation = cmp_info_style,
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            -- custom comparator for making spell sources work.
            -- (basically compare.order but for spell source only)
            function(a, b)
              if a.source.name ~= 'spell' or b.source.name ~= 'spell' then
                return nil
              end
              local diff = a.id - b.id
              if diff < 0 then
                return true
              elseif diff > 0 then
                return false
              end
              return nil
            end,
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.locality,
            compare.kind,
            compare.length,
            compare.order,
          },
        },
        experimental = {
          ghost_text = true,
        },
      }

      -- Insert `(` after select function or method item
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp_mappings,
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          {
            name = 'cmdline',
            keyword_length = 2,
            option = {
              ignore_cmds = {},
            },
          },
        }),
      })
      cmp.setup(cmp_config)
    end,
  },
}
