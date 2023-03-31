return {
  {
    'williamboman/mason.nvim',
    lazy = true,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = true,
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()

      require("mason-lspconfig").setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {}
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, set up `rust-tools` with `rust-analyzer`
        ["lua_ls"] = function()
          require 'lspconfig'.lua_ls.setup {
            settings = {
              Lua = {
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { 'vim' },
                },
              },
            },
          }
        end
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, remap = false, silent = true }
          vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {})
          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
          -- ^^ go back with <C-o>
          vim.keymap.set("n", "gD", "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", opts)
          vim.keymap.set("n", "gE", function() vim.diagnostic.goto_prev() end, opts)
          vim.keymap.set("n", "ge", function() vim.diagnostic.goto_next() end, opts)
          vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts)
        end
      })

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = { border = 'single' },
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })
    end
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'VeryLazy' },
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.deno_fmt.with({
            extra_args = { "--single-quote" }
          }),
          null_ls.builtins.formatting.clang_format.with({
            extra_args = { "--style", "{IndentWidth: 4}" }
          }),
        },
      })
    end
  },
}
