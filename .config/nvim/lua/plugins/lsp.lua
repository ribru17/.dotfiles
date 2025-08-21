---@diagnostic disable: inject-field
local BORDER_STYLE = require('rileybruins.settings').border
local SETTINGS = require('rileybruins.settings')

local diagnostic_ns = vim.api.nvim_create_namespace('hldiagnosticregion')
local diagnostic_timer
local hl_cancel
local diag_level = vim.diagnostic.severity
local hl_map = {
  [diag_level.ERROR] = 'DiagnosticVirtualTextError',
  [diag_level.WARN] = 'DiagnosticVirtualTextWarn',
  [diag_level.HINT] = 'DiagnosticVirtualTextHint',
  [diag_level.INFO] = 'DiagnosticVirtualTextInfo',
}

---@param dir 'prev'|'next'
local function goto_diagnostic_hl(dir)
  assert(dir == 'prev' or dir == 'next')
  local diagnostic = vim.diagnostic['get_' .. dir]()
  if not diagnostic then
    return
  end
  if diagnostic_timer then
    diagnostic_timer:close()
    hl_cancel()
  end
  vim.api.nvim_buf_set_extmark(
    0,
    diagnostic_ns,
    diagnostic.lnum,
    diagnostic.col,
    {
      end_row = diagnostic.end_lnum,
      end_col = diagnostic.end_col,
      hl_group = hl_map[diagnostic.severity],
    }
  )
  hl_cancel = function()
    diagnostic_timer = nil
    hl_cancel = nil
    pcall(vim.api.nvim_buf_clear_namespace, 0, diagnostic_ns, 0, -1)
  end
  diagnostic_timer = vim.defer_fn(hl_cancel, 500)
  vim.diagnostic['goto_' .. dir]()
end

return {
  {
    'mrcjkb/haskell-tools.nvim',
    ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
    version = '^3',
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'LazyFile' },
    config = function()
      require('lspconfig.ui.windows').default_options.border = BORDER_STYLE
      local lspconfig = require('lspconfig')
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local custom_capabilities = require('blink.cmp').get_lsp_capabilities()
      custom_capabilities.offsetEncoding = { 'utf-16' }
      lspconfig.vtsls.setup {
        capabilities = capabilities,
      }
      lspconfig.clangd.setup {
        capabilities = custom_capabilities,
        -- NOTE: to achieve LSP warnings on unused includes, add a `.clangd`
        -- file to the project directory containing:
        -- ```
        -- Diagnostics:
        -- UnusedIncludes: Strict
        -- MissingIncludes: Strict
        -- ```
        cmd = {
          'clangd',
          '--header-insertion-decorators=false',
          '--enable-config',
          '--completion-style=detailed',
          '--background-index',
          '--clang-tidy',
          '--include-cleaner-stdlib',
          '--header-insertion=iwyu',
          '--completion-style=detailed',
          '--function-arg-placeholders',
          '--fallback-style=llvm',
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      }
      local emmet_fts =
        lspconfig.emmet_language_server.document_config.default_config.filetypes
      -- These are the default filetypes less the ones that are covered by
      -- `cssls`. The two (sort of) conflict, and `cssls` is better. I
      -- don't use Emmet CSS abbreviations anyway.
      local ignored_fts =
        lspconfig.cssls.document_config.default_config.filetypes
      local filtered_fts = vim.tbl_filter(function(value)
        return not vim.tbl_contains(ignored_fts, value)
      end, emmet_fts)
      lspconfig.emmet_language_server.setup {
        capabilities = capabilities,
        filetypes = filtered_fts,
        init_options = {
          preferences = {
            ['caniuse.enabled'] = false,
          },
        },
      }
      lspconfig.biome.setup {
        capabilities = capabilities,
      }
      lspconfig.eslint.setup {
        capabilities = capabilities,
      }
      lspconfig.gopls.setup {
        capabilities = capabilities,
        settings = {
          gopls = {
            semanticTokens = true,
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      }
      lspconfig.basedpyright.setup {
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = 'standard',
              autoSearchPaths = true,
            },
          },
        },
      }
      lspconfig.bashls.setup {
        capabilities = capabilities,
      }
      lspconfig.cmake.setup {
        capabilities = capabilities,
      }
      lspconfig.cssls.setup {
        capabilities = capabilities,
      }
      lspconfig.jsonls.setup {
        capabilities = capabilities,
      }
      lspconfig.html.setup {
        capabilities = capabilities,
      }
      lspconfig.marksman.setup {
        capabilities = capabilities,
      }
      lspconfig.nil_ls.setup {
        capabilities = capabilities,
        settings = {
          ['nil'] = {
            formatting = {
              command = { 'nixfmt' },
            },
            nix = {
              flake = {
                autoArchive = true,
              },
            },
          },
        },
      }
      lspconfig.r_language_server.setup {
        capabilities = capabilities,
      }
      lspconfig.ruff.setup {
        capabilities = capabilities,
      }
      lspconfig.yamlls.setup {
        capabilities = capabilities,
      }
      lspconfig.taplo.setup {
        capabilities = capabilities,
      }
      lspconfig.zls.setup {
        capabilities = capabilities,
      }

      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            codeLens = { enable = true },
            hint = {
              enable = true,
              await = false,
              arrayIndex = 'Disable',
            },
            format = {
              enable = false,
            },
          },
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        -- to disable qflist opening, see
        -- https://github.com/neovim/neovim/pull/19213
        callback = function(ev)
          local attached_client = ev.data
              and vim.lsp.get_client_by_id(ev.data.client_id)
            or nil
          if
            attached_client
            and attached_client.server_capabilities.codeLensProvider
          then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd(SETTINGS.codelens_refresh_events, {
              buffer = ev.buf,
              group = vim.api.nvim_create_augroup(
                'CodelensRefresh',
                { clear = true }
              ),
              callback = vim.lsp.codelens.refresh,
            })
          end
          local map = vim.keymap.set
          local opts = { buffer = ev.buf, remap = false, silent = true }

          vim.lsp.inlay_hint.enable()

          -- if action opens up qf list, open the first item and close the list
          local function choose_list_first(options)
            vim.fn.setqflist({}, ' ', options)
            vim.cmd.cfirst()
          end

          map('n', 'K', function()
            vim.lsp.buf.hover { border = BORDER_STYLE }
          end, opts)
          map('n', '<leader>e', vim.diagnostic.open_float, opts)
          -- go back with <C-o>, forth with <C-i>
          map('n', 'gd', function()
            vim.lsp.buf.definition { on_list = choose_list_first }
          end, opts)
          map('n', 'gD', function()
            vim.cmd.split { mods = { tab = vim.fn.tabpagenr() + 1 } }
            vim.lsp.buf.definition { on_list = choose_list_first }
          end, opts)
          map('n', '<leader>gd', vim.lsp.buf.declaration, opts)
          map(
            'n',
            '<leader>gD',
            '<cmd>tab split | lua vim.lsp.buf.declaration()<CR>',
            opts
          )
          map('n', 'gt', vim.lsp.buf.type_definition, opts)
          map(
            'n',
            'gT',
            '<cmd>tab split | lua vim.lsp.buf.type_definition()<CR>',
            opts
          )
          map('n', 'gi', function()
            vim.cmd.FzfLua('lsp_implementations')
          end, opts)
          map('n', 'gI', function()
            vim.cmd.split { mods = { tab = vim.fn.tabpagenr() + 1 } }
            vim.lsp.buf.implementation { on_list = choose_list_first }
          end, opts)
          map('n', 'gr', function()
            vim.cmd.FzfLua('lsp_references')
          end, opts)
          map('n', '<leader>dk', function()
            goto_diagnostic_hl('prev')
          end, opts)
          map('n', '<leader>dj', function()
            goto_diagnostic_hl('next')
          end, opts)
          -- rename symbol starting with empty prompt, highlight references
          map('n', '<leader>r', function()
            local bufnr = vim.api.nvim_get_current_buf()
            local params = vim.lsp.util.make_position_params(nil, 'utf-8')
            params.context = { includeDeclaration = true }
            local clients = vim.lsp.get_clients()
            if not clients or #clients == 0 then
              vim.print('No attached clients.')
              return
            end
            local client = clients[1]
            for _, possible_client in pairs(clients) do
              if possible_client.server_capabilities.renameProvider then
                client = possible_client
                break
              end
            end
            local ns = vim.api.nvim_create_namespace('LspRenamespace')

            client:request(
              'textDocument/references',
              params,
              function(_, result)
                if result and not vim.tbl_isempty(result) then
                  for _, v in ipairs(result) do
                    if v.range then
                      local buf = vim.uri_to_bufnr(v.uri)
                      local start_line = v.range.start.line
                      local start_char = v.range.start.character
                      local end_line = v.range['end'].line
                      local end_char = v.range['end'].character
                      if buf == bufnr then
                        vim.hl.range(
                          bufnr,
                          ns,
                          'LspReferenceWrite',
                          { start_line, start_char },
                          { end_line, end_char }
                        )
                      end
                    end
                  end
                  vim.cmd.redraw()
                end

                local new_name = vim.fn.input { prompt = 'New name: ' }
                vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
                if #new_name == 0 then
                  return
                end
                vim.lsp.buf.rename(new_name)
              end,
              bufnr
            )
          end)
          -- show code actions, executing if only 1
          map('n', '<leader>ca', function()
            require('fzf-lua').lsp_code_actions { silent = true }
          end, opts)
          map('n', '<leader>cl', vim.lsp.codelens.run, opts)
        end,
      })

      vim.diagnostic.config {
        virtual_text = true,
        signs = {
          text = {
            [diag_level.ERROR] = ' ',
            [diag_level.WARN] = ' ',
            [diag_level.INFO] = '󰌶 ',
            [diag_level.HINT] = ' ',
          },
          texthl = {
            [diag_level.ERROR] = 'DiagnosticSignError',
            [diag_level.WARN] = 'DiagnosticSignWarn',
            [diag_level.INFO] = 'DiagnosticSignInfo',
            [diag_level.HINT] = 'DiagnosticSignHint',
          },
          numhl = {
            [diag_level.ERROR] = 'DiagnosticSignError',
            [diag_level.WARN] = 'DiagnosticSignWarn',
            [diag_level.INFO] = 'DiagnosticSignInfo',
            [diag_level.HINT] = 'DiagnosticSignHint',
          },
        },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = { border = BORDER_STYLE },
      }

      -- Create a custom namespace. This will aggregate signs from all other
      -- namespaces and only show the one with the highest severity on a
      -- given line
      local ns = vim.api.nvim_create_namespace('my_namespace')
      -- Get a reference to the original signs handler
      local orig_signs_handler = vim.diagnostic.handlers.signs
      -- Override the built-in signs handler
      vim.diagnostic.handlers.signs = {
        show = function(_, bufnr, _, opts)
          -- Get all diagnostics from the whole buffer rather than just the
          -- diagnostics passed to the handler
          local diagnostics = vim.diagnostic.get(bufnr)
          -- Find the "worst" diagnostic per line
          local max_severity_per_line = {}
          for _, d in pairs(diagnostics) do
            local m = max_severity_per_line[d.lnum]
            if not m or d.severity < m.severity then
              max_severity_per_line[d.lnum] = d
            end
          end
          -- Pass the filtered diagnostics (with our custom namespace) to
          -- the original handler
          local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
          orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
        end,
        hide = function(_, bufnr)
          orig_signs_handler.hide(ns, bufnr)
        end,
      }
    end,
  },
}
