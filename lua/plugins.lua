return {
    {
        'windwp/nvim-autopairs',
        dependencies = {
            'hrsh7th/nvim-cmp'
        },
        config = function()
            require('nvim-autopairs').setup {}

            -- Insert `(` after select function or method item
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end
    },
    {
        'rust-lang/rust.vim',
        ft = 'rust'
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require 'nvim-treesitter.configs'.setup {
                -- A list of parser names, or "all" (the first five parsers should always be installed)
                ensure_installed = { "c", "lua", "vim", "help", "query", "javascript", "typescript", "rust", "tsx" },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = true,

                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,
                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
                -- HTML-style tag completion
                autotag = {
                    enable = true,
                },
                indent = {
                    enable = true
                }
            }
        end
    },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        config = function()
            require("catppuccin").setup {
                integrations = {
                    indent_blankline = {
                        enabled = true,
                        colored_indent_levels = true,
                    }
                }
            }
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local actions = require('telescope.actions')
            require("telescope").setup({
                defaults = {
                    layout_config = {
                        horizontal = {
                            preview_cutoff = 0,
                        },
                    },
                    prompt_prefix = '🔎 ',
                    initial_mode = "normal",
                    mappings = {
                        n = {
                            ["<Tab>"] = actions.select_tab, -- <Tab> to open as tab
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                        },
                        i = {
                            ["<Tab>"] = actions.select_tab, -- <Tab> to open as tab
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                        }
                    }
                },
            })

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', function()
                builtin.find_files {
                    find_command = function()
                        return { 'rg', '--files', '-g',
                            '!' .. string.gsub(vim.api.nvim_buf_get_name(0), vim.loop.cwd(), '') }
                    end
                }
            end
            , {})
            vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
            vim.keymap.set('n', '<leader>sf', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") });
            end, {})
        end
    },
    'tpope/vim-fugitive',
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },         -- Required
            { 'hrsh7th/cmp-nvim-lsp' },     -- Required
            { 'hrsh7th/cmp-buffer' },       -- Optional
            { 'hrsh7th/cmp-path' },         -- Optional
            { 'saadparwaiz1/cmp_luasnip' }, -- Optional
            { 'hrsh7th/cmp-nvim-lua' },     -- Optional
            { 'onsails/lspkind-nvim' },     --Optional

            -- Snippets
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
            }, -- Required
        },
        config = function()
            local lsp = require('lsp-zero')
            local cmp = require('cmp')
            local lspkind = require('lspkind')

            lsp.preset('recommended')

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

            lsp.setup_nvim_cmp({
                mapping = cmp_mappings,
                sources = {
                    { name = 'path' },
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
            })

            lsp.on_attach(function(_, bufnr)
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {})
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                -- ^^ go back with <C-o>
                vim.keymap.set("n", "gD", "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", opts)
                vim.keymap.set("n", "gE", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "ge", function() vim.diagnostic.goto_next() end, opts)
                --vim.keymap.set("n", "ge", function() vim.lsp.buf.rename() end, opts)
            end)

            lsp.setup()
        end
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({
                toggler = {
                    line = '<C-_>',
                },
                opleader = {
                    line = '<C-_>'
                },
            })
        end
    },
    {
        'iamcco/markdown-preview.nvim',
        ft = 'markdown',
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        --event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
                aliases = {
                    ["d"] = { "{", "[", "(", "<", '"', "'", "`" }, -- any delimiter
                    ["b"] = { "{", "[", "(", "<" },                -- bracket
                }
            })
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            -- Custom statusline that shows total line number with current
            local function line_total()
                local curs = vim.api.nvim_win_get_cursor(0)
                return curs[1] .. "/" .. vim.api.nvim_buf_line_count(vim.fn.winbufnr(0)) .. "," .. curs[2]
            end

            require('lualine').setup {
                sections = {
                    lualine_z = { line_total }
                },
            }
        end
    },
    'kyazdani42/nvim-web-devicons',
    {
        'akinsho/bufferline.nvim',
        dependencies = {
            'catppuccin/nvim'
        },
        config = function()
            require('bufferline').setup {
                options = {
                    mode = "tabs",
                    separator_style = "slant",
                    color_icons = true,
                    show_close_icon = false,
                    show_buffer_close_icons = false,
                    modified_icon = "",
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level)
                        local icon = level:match("error") and "" or ""
                        return icon .. " " .. count
                    end,
                },
                highlights = require("catppuccin.groups.integrations.bufferline").get()
            }
        end
    },
    'windwp/nvim-ts-autotag',
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- next/prev git changes
                    map('n', '<leader>gj', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, { expr = true })

                    map('n', '<leader>gk', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, { expr = true })

                    -- git preview
                    map('n', '<leader>gp', gs.preview_hunk)
                    -- git blame
                    map('n', '<leader>gb', function() gs.blame_line { full = true } end)
                    -- undo git change
                    map('n', '<leader>gu', gs.reset_hunk)
                end,
            })
        end
    },
    {
        'jose-elias-alvarez/null-ls.nvim',
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
    'tpope/vim-abolish',
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                -- reduce indentation clutter
                -- https://www.reddit.com/r/neovim/comments/yiodnb/proper_configuration_for_indentblankline/
                max_indent_increase = 1,
                --> Uncomment to get colored indent lines
                -- char_highlight_list = {
                --     "IndentBlanklineIndent1",
                --     "IndentBlanklineIndent2",
                --     "IndentBlanklineIndent3",
                --     "IndentBlanklineIndent4",
                --     "IndentBlanklineIndent5",
                --     "IndentBlanklineIndent6",
                -- },
            }
        end
    },
    {
        'iurimateus/luasnip-latex-snippets.nvim',
        config = function()
            require('luasnip-latex-snippets').setup({ use_treesitter = true })
        end
    }
}
