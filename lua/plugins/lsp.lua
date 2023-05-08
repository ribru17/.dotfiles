return {
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason' },
    lazy = true,
    config = true,
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
    branch = '1.x.x',
    config = function()
      local ht = require('haskell-tools')
      -- local buffer = vim.api.nvim_get_current_buf()
      -- local def_opts = { noremap = true, silent = true }
      ht.start_or_attach {
        -- hls = {
        --   on_attach = function(_, bufnr)
        --     local opts = vim.tbl_extend('keep', def_opts, { buffer = bufnr })
        --     -- haskell-language-server relies heavily on codeLenses,
        --     -- so auto-refresh (see advanced configuration) is enabled by default
        --     -- vim.keymap.set('n', '<leader>ca', vim.lsp.codelens.run, opts)
        --     -- vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts)
        --     -- buggy and sort of useless
        --     -- vim.keymap.set('n', '<leader>ha', ht.lsp.buf_eval_all, opts)
        --   end,
        -- },
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup()

      require('mason-lspconfig').setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          require('lspconfig')[server_name].setup {}
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, set up `rust-tools` with `rust-analyzer`
        ['lua_ls'] = function()
          require 'lspconfig'.lua_ls.setup {
            settings = {
              Lua = {
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { 'vim' },
                },
                telemetry = { enable = false },
                runtime = {
                  version = 'LuaJIT',
                },
                -- see https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                format = {
                  enable = true,
                  defaultConfig = {
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
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.offsetEncoding = { 'utf-16' }
          require('lspconfig').clangd.setup {
            capabilities = capabilities,
            cmd = { 'clangd', '--header-insertion-decorators=false' },
          }
        end,
        ['cssls'] = function()
          --Enable (broadcasting) snippet capability for completion
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true

          require 'lspconfig'.cssls.setup {
            capabilities = capabilities,
          }
        end,
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, remap = false, silent = true }
          vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {})
          vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end,
            opts)
          -- ^^ go back with <C-o>
          vim.keymap.set('n', 'gD',
            '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', opts)
          vim.keymap.set('n', '<leader>dk',
            function() vim.diagnostic.goto_prev() end,
            opts)
          vim.keymap.set('n', '<leader>dj',
            function() vim.diagnostic.goto_next() end,
            opts)
          vim.keymap.set('n', '<leader>r', function()
            local new_name = vim.fn.input { prompt = 'New name: ' }
            if #new_name == 0 then
              return
            end
            vim.lsp.buf.rename(new_name)
          end)
          vim.keymap.set('n', '<leader>ca', function()
            vim.lsp.buf.code_action {
              apply = true,
            }
          end, opts)
          vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
        end,
      })

      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = { border = 'single' },
      }

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = 'rounded',
        })
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
          border = 'rounded',
        })

      local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
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
    end,
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'LspAttach' },
    ft = { 'markdown' }, -- other lsp's covered by LspAttach
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
              '{IndentWidth: 4, AllowShortFunctionsOnASingleLine: Empty}', },
          },
          null_ls.builtins.formatting.prettierd.with {
            filetypes = { 'css', 'html' },
          },
        },
      }
    end,
  },
}
