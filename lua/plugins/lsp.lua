return {
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason' },
    lazy = true,
    config = function()
      require('mason').setup {
        ui = {
          border = 'rounded',
        },
      }
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = true,
  },
  {
    'mrcjkb/haskell-tools.nvim',
    ft = 'haskell',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    branch = '2.x.x',
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = { 'denols', 'emmet_ls', 'cssls' },
      }

      require('lspconfig.ui.windows').default_options.border = 'rounded'

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      require('mason-lspconfig').setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
          }
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, set up `rust-tools` with `rust-analyzer`
        ['lua_ls'] = function()
          require 'lspconfig'.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  -- Uncomment to receive LSP formatting diagnostics.
                  -- neededFileStatus = { ['codestyle-check'] = 'Any' },
                },
                telemetry = { enable = false },
                runtime = {
                  version = 'LuaJIT',
                },
                workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = {
                    vim.fn.expand '$VIMRUNTIME',
                    '${3rd}/luassert/library',
                  },
                },
                -- see https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                format = {
                  enable = true,
                  defaultConfig = {
                    indent_size = '2',
                    indent_style = 'space',
                    quote_style = 'single',
                    max_line_length = '80',
                    trailing_table_separator = 'smart',
                    -- NOTE: some options break some formatting properties? :(
                    -- in fact a lot of things are buggy (removing `quote_style`
                    -- property allows trailing table separators to be more
                    -- comprehensive) but... good enough :)
                    -- break_all_list_when_line_exceed = true, --breaks things sadly
                    call_arg_parentheses = 'remove_table_only',
                    -- align_call_args = true, -- breaks things sadly
                  },
                },
              },
            },
          }
        end,
        ['clangd'] = function()
          local custom_capabilities = require('cmp_nvim_lsp')
              .default_capabilities()
          custom_capabilities.offsetEncoding = { 'utf-16' }
          require 'lspconfig'.clangd.setup {
            capabilities = custom_capabilities,
            cmd = { 'clangd', '--header-insertion-decorators=false' },
          }
        end,
        ['cssls'] = function()
          --Enable (broadcasting) snippet capability for completion
          local custom_capabilities = require('cmp_nvim_lsp')
              .default_capabilities()
          custom_capabilities.textDocument.completion.completionItem.snippetSupport = true

          require 'lspconfig'.cssls.setup {
            capabilities = custom_capabilities,
          }
        end,
        ['hls'] = function()
          -- do nothing in case user installed lsp with Mason
          -- this prevents conflicts with the haskell tools plugin
        end,
        ['tsserver'] = function()
          -- don't set up, conflicts with typescript-tools.nvim
        end,
        ['denols'] = function()
          -- don't set up LSP, we only want formatting
        end,
        ['emmet_ls'] = function()
          local ls = require('luasnip')
          require 'lspconfig'.emmet_ls.setup {
            capabilities = capabilities,
            filetypes = { 'css', 'eruby', 'html', 'javascript',
              'javascriptreact', 'less', 'sass', 'scss', 'svelte', 'pug',
              'typescriptreact', 'vue' },
            on_attach = function(client, bufnr)
              -- https://github.com/aca/emmet-ls/issues/42
              vim.keymap.set('i', '<S-CR>', function()
                -- this request must be synchronous to allow for it to allow
                -- luasnip session to end properly
                local res = client.request_sync(
                  'textDocument/completion',
                  vim.lsp.util.make_position_params(),
                  -- timeout for LSP call
                  250,
                  bufnr
                )
                if not res or #res.result == 0 then
                  vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes('<CR>', true, false, true),
                    'n',
                    false)
                  return
                end
                local textEdit = res.result[1].textEdit
                local snip_string = textEdit.newText
                textEdit.newText = ''
                vim.lsp.util.apply_text_edits({ textEdit }, bufnr,
                  client.offset_encoding)
                ls.lsp_expand(snip_string)
              end, { buffer = bufnr })
            end,
          }
        end,
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        -- to disable qflist opening, see
        -- https://github.com/neovim/neovim/pull/19213
        callback = function(ev)
          local map = vim.keymap.set
          local opts = { buffer = ev.buf, remap = false, silent = true }
          local foldPreview = require('ufo').peekFoldedLinesUnderCursor

          -- if action opens up quickfix list, open the first item and close
          -- the list
          local function on_list(options)
            vim.fn.setqflist({}, ' ', options)
            vim.cmd.cfirst()
          end

          map('n', 'K', vim.lsp.buf.hover, opts)
          map('n', 'K', function()
            local winid = foldPreview()
            if not winid then
              vim.lsp.buf.hover()
            end
          end, opts)
          map('n', '<leader>e', vim.diagnostic.open_float, opts)
          -- go back with <C-o>, forth with <C-i>
          map('n', 'gd',
            function() vim.lsp.buf.definition { on_list = on_list } end, opts)
          map('n', 'gD', function()
            vim.cmd.split { mods = { tab = vim.fn.tabpagenr() + 1 } }
            vim.lsp.buf.definition { on_list = on_list }
          end, opts)
          map('n', 'gc', vim.lsp.buf.declaration, opts)
          map('n', 'gC', '<cmd>tab split | lua vim.lsp.buf.declaration()<CR>',
            opts)
          map('n', 'gt', vim.lsp.buf.type_definition, opts)
          map('n', 'gT', '<cmd>tab split | lua vim.lsp.buf.type_definition()<CR>',
            opts)
          map('n', 'gi', vim.lsp.buf.implementation, opts)
          map('n', 'gI', '<cmd>tab split | lua vim.lsp.buf.implementation()<CR>',
            opts)
          map('n', '<leader>dk', vim.diagnostic.goto_prev, opts)
          map('n', '<leader>dj', vim.diagnostic.goto_next, opts)
          -- rename symbol starting with empty prompt, highlight references
          map('n', '<leader>r', function()
            local bufnr = vim.api.nvim_get_current_buf()
            local params = vim.lsp.util.make_position_params()
            params.context = { includeDeclaration = true }
            local clients = vim.lsp.get_active_clients()
            local client = clients[1]
            for _, value in ipairs(clients) do
              if value.name ~= 'null-ls' then
                client = value
              end
            end
            local ns = vim.api.nvim_create_namespace('LspRenamespace')

            client.request('textDocument/references', params,
              function(_, result)
                if not result then
                  vim.print('Cannot rename.')
                  return
                end

                for _, v in ipairs(result) do
                  if v.range then
                    local buf = vim.uri_to_bufnr(v.uri)
                    local line = v.range.start.line
                    local start_char = v.range.start.character
                    local end_char = v.range['end'].character
                    if buf == bufnr then
                      print(line, start_char, end_char)
                      vim.api.nvim_buf_add_highlight(bufnr, ns,
                        'LspReferenceWrite', line, start_char, end_char)
                    end
                  end
                end
                vim.cmd.redraw()
                local new_name = vim.fn.input { prompt = 'New name: ' }
                vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
                if #new_name == 0 then
                  return
                end
                vim.lsp.buf.rename(new_name)
              end, bufnr)
          end)
          -- show code actions, executing if only 1
          map('n', '<leader>ca', function()
            vim.lsp.buf.code_action {
              apply = true,
            }
          end, opts)
          map('n', '<leader>cl', vim.lsp.codelens.run, opts)
        end,
      })

      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = { border = 'rounded' },
      }

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = 'rounded',
        })
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
          border = 'rounded',
        })

      local signs = { Error = ' ', Warn = ' ', Hint = '󰌶 ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

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

      -- auto-install some packages that cannot be handled by `ensure_installed`
      local registry = require 'mason-registry'
      local packages = {
        'prettierd',
        'clang-format',
      }
      registry.refresh(function()
        for _, pkg_name in ipairs(packages) do
          local pkg = registry.get_package(pkg_name)
          if not pkg:is_installed() then
            pkg:install()
          end
        end
      end)
    end,
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'LspAttach' },
    -- other filetypes not covered by LspAttach (as they have no LSP)
    ft = { 'markdown', 'json' },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local null_ls = require('null-ls')

      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.deno_fmt.with {
            extra_args = { '--single-quote' },
          },
          null_ls.builtins.formatting.clang_format.with {
            -- https://clang.llvm.org/docs/ClangFormatStyleOptions.html
            extra_args = { '--style',
              '{IndentWidth: 4, AllowShortFunctionsOnASingleLine: Empty}' },
            filetypes = { 'c', 'cpp' },
          },
          null_ls.builtins.formatting.prettierd.with {
            filetypes = { 'css', 'html' },
          },
        },
      }
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    opts = {},
  },
}
