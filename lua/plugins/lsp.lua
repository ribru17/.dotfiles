return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    event = { 'VeryLazy' },
    dependencies = {
      {
        'williamboman/mason.nvim',
        cmd = 'Mason'
      },
      { 'williamboman/mason-lspconfig.nvim', },
      { 'neovim/nvim-lspconfig', },
      { 'hrsh7th/nvim-cmp', },
      { 'hrsh7th/cmp-nvim-lsp', },
      { 'hrsh7th/cmp-buffer', },
      { 'hrsh7th/cmp-path', },
      { 'saadparwaiz1/cmp_luasnip', },
      { 'hrsh7th/cmp-nvim-lua', },
      { 'onsails/lspkind-nvim', },
      {
        'L3MON4D3/LuaSnip',
        config = function()
          local ls = require('luasnip')
          local s = ls.snippet
          local i = ls.insert_node
          -- local t = ls.text_node
          local fmt = require("luasnip.extras.fmt").fmt
          local conds = require("luasnip.extras.expand_conditions")

          ls.add_snippets("html", {
            s({
              trig = "!",
              name = "Emmet HTML5 Boilerplate",
              dscr = "Creates a barebones HTML5 application."
            }, fmt([[
   <!DOCTYPE html>
   <html lang="en">
   <head>
     <meta charset="UTF-8">
     <meta http-equiv="X-UA-Compatible" content="IE=edge">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <title>{1}</title>
   </head>
   <body>
     {2}
   </body>
   </html>{3}
    ]], {
              i(1, 'Document'),
              i(2, ''),
              i(3, ''),
            }), {
              condition = conds.line_begin,
            }),
          })

          ls.add_snippets("all", {
            s(
              {
                trig = 'lorem',
                name = 'Lorem Ipsum Text',
                dscr = 'Generates a long lorem ipsum text.'
              },
              fmt(
                [[Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Aliquet nec ullamcorper sit amet. Volutpat diam ut venenatis tellus in. Egestas sed sed risus pretium quam vulputate dignissim suspendisse. Sapien pellentesque habitant morbi tristique senectus et netus et malesuada. Eu feugiat pretium nibh ipsum. Convallis aenean et tortor at risus viverra. Libero volutpat sed cras ornare arcu. Pharetra vel turpis nunc eget lorem dolor sed viverra. Lacus laoreet non curabitur gravida arcu ac tortor dignissim. Ut eu sem integer vitae justo eget magna fermentum. Leo duis ut diam quam nulla porttitor massa id. Purus sit amet volutpat consequat mauris nunc congue. Eget lorem dolor sed viverra ipsum nunc aliquet bibendum. Cursus risus at ultrices mi.]],
                {}
              ),
              {}
            ),
          })
        end
      },
    },
    config = function()
      local lsp = require('lsp-zero')
      local cmp = require('cmp')
      local lspkind = require('lspkind')

      lsp.preset({
        name = 'recommended',
        manage_nvim_cmp = false,
        set_lsp_keymaps = false,
      })

      -- Suppress irritating `undefined global vim` errors
      lsp.nvim_workspace()

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
            vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      -- supertab functionality
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local luasnip = require('luasnip')
      local cmp_mappings = lsp.defaults.cmp_mappings({
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
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s", }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping(function(fallback)
          fallback()
        end),
      })

      local cmp_config = lsp.defaults.cmp_config({
        mapping = cmp_mappings,
        sources = {
          { name = 'path' },
          { name = 'nvim_lua' },
          { name = 'nvim_lsp' },
          { name = 'luasnip', keyword_length = 2 },
          { name = 'buffer',  keyword_length = 3 },
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",  -- show only symbol annotations
            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(_, vim_item)
              return vim_item
            end,
          }),
        },
        window = {
          completion = cmp.config.window.bordered()
        },
      })

      local palettes = require('catppuccin.palettes').get_palette()
      vim.api.nvim_set_hl(0, "CmpItemAbbr", { ctermbg = 0, fg = palettes.text })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { ctermbg = 0, fg = palettes.blue })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { ctermbg = 0, fg = palettes.blue })

      cmp.setup(cmp_config)

      lsp.on_attach(function(_, bufnr)
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {})
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        -- ^^ go back with <C-o>
        vim.keymap.set("n", "gD", "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", opts)
        vim.keymap.set("n", "gE", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "ge", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts)
      end)

      lsp.setup()

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = true,
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
