local BORDER = require('rileybruins.settings').border
local in_jsx = require('rileybruins.utils').in_jsx_tags
local keep_text_entries = { 'emmet_language_server', 'marksman' }
local text = vim.lsp.protocol.CompletionItemKind.Text
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
    'saghen/blink.cmp',
    dependencies = { 'ribru17/blink-cmp-spell' },
    event = { 'InsertEnter', 'CmdlineEnter' },
    build = 'nix run .#build-plugin',
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

        sources = {
          default = { 'lsp', 'path', 'luasnip', 'spell' },
          cmdline = function()
            if vim.fn.getcmdtype() == ':' then
              return { 'cmdline' }
            end
            return {}
          end,
          providers = {
            spell = {
              name = 'Spell',
              module = 'blink-cmp-spell',
              opts = {
                -- Disable the source in `@nospell` captures
                enable_in_context = function()
                  return not vim.tbl_contains(
                    vim.treesitter.get_captures_at_cursor(0),
                    'nospell'
                  )
                end,
              },
            },
            luasnip = {
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
          expand = function(snippet)
            require('luasnip').lsp_expand(snippet)
          end,
          active = function(filter)
            local luasnip = require('luasnip')
            if filter and filter.direction then
              return luasnip.jumpable(filter.direction)
            end
            return luasnip.in_snippet()
          end,
          jump = function(direction)
            require('luasnip').jump(direction)
          end,
        },

        completion = {
          menu = {
            border = BORDER,
            draw = {
              columns = {
                { 'label', 'label_description', gap = 1 },
                { 'kind_icon', 'kind' },
                { 'source_name' },
              },
            },
          },
          ghost_text = {
            enabled = true,
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 50,
            window = { border = BORDER },
          },
        },
      }
    end,
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { 'sources.default' },
  },
}
