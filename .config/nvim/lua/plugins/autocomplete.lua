local in_jsx = require('rileybruins.utils').in_jsx_tags
local keep_text_entries = { 'emmet_language_server', 'marksman' }
local text = vim.lsp.protocol.CompletionItemKind.Text
return {
  {
    -- NOTE: Maybe replace with ultimate-autopair after the following issue is
    -- fixed: https://github.com/altermo/ultimate-autopair.nvim/issues/5.
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' },
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
    end,
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'ribru17/blink-cmp-spell' },
    event = { 'InsertEnter', 'CmdlineEnter' },
    version = '*',
    config = function()
      local blink = require('blink.cmp')
      local sort_text = require('blink.cmp.fuzzy.sort').sort_text
      blink.setup {
        keymap = {
          preset = 'default',
          ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
          ['<C-y>'] = {
            'select_and_accept',
            vim.schedule_wrap(function()
              local luasnip = require('luasnip')
              if luasnip.expandable() then
                luasnip.expand()
              end
            end),
          },
        },

        appearance = {
          nerd_font_variant = 'normal',
        },

        fuzzy = {
          sorts = {
            function(a, b)
              if a.source_id == 'spell' and b.source_id == 'spell' then
                return sort_text(a, b)
              end
            end,
            'score',
            'sort_text',
          },
        },

        cmdline = {
          completion = {
            menu = {
              auto_show = function()
                return vim.fn.getcmdtype() == ':'
                  -- enable for inputs as well, with:
                  or vim.fn.getcmdtype() == '@'
              end,
            },
          },
          sources = function()
            if vim.fn.getcmdtype() == ':' then
              return { 'cmdline' }
            end
            return {}
          end,
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'spell' },
          providers = {
            spell = {
              name = 'Spell',
              module = 'blink-cmp-spell',
              opts = {
                -- Only enable source in `@spell` captures, and disable it in
                -- `@nospell` captures
                preselect_current_word = false,
                keep_all_entries = false,
                enable_in_context = function()
                  local curpos = vim.api.nvim_win_get_cursor(0)
                  local captures = vim.treesitter.get_captures_at_pos(
                    0,
                    curpos[1] - 1,
                    curpos[2] - 1
                  )
                  local in_spell_capture = false
                  for _, cap in ipairs(captures) do
                    if cap.capture == 'spell' then
                      in_spell_capture = true
                    elseif cap.capture == 'nospell' then
                      return false
                    end
                  end
                  return in_spell_capture
                end,
              },
            },
            snippets = {
              opts = {
                show_autosnippets = false,
              },
            },
            lsp = {
              async = true,
              transform_items = function(ctx, items)
                -- Remove the "Text" source from lsp autocomplete
                local ft = vim.bo[ctx.bufnr].filetype
                return vim.tbl_filter(function(item)
                  local client = vim.lsp.get_client_by_id(item.client_id)
                  local client_name = client and client.name or ''
                  if
                    client_name == 'emmet_language_server'
                    and (ft == 'javascriptreact' or ft == 'typescriptreact')
                  then
                    return in_jsx(true)
                  end
                  return item.kind ~= text
                    or vim.tbl_contains(keep_text_entries, client_name)
                end, items)
              end,
            },
          },
        },

        snippets = {
          preset = 'luasnip',
        },

        completion = {
          menu = {
            draw = {
              columns = {
                { 'label', 'label_description', gap = 1 },
                { 'kind_icon', 'kind' },
                { 'source_name' },
              },
            },
          },
          accept = {
            auto_brackets = { blocked_filetypes = { 'query' } },
          },
          ghost_text = {
            enabled = true,
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 50,
          },
        },
      }
    end,
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { 'sources.default' },
  },
}
