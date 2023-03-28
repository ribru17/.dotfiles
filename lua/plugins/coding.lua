return {
    {
        'rust-lang/rust.vim',
        ft = 'rust',
    },
    {
        'tpope/vim-fugitive',
        cmd = 'Git'
    },
    {
        'tpope/vim-abolish',
        cmd = 'S'
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
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
        'numToStr/Comment.nvim',
        event = { 'VeryLazy' },
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
        'windwp/nvim-ts-autotag',
        ft = { 'html', 'xml', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx',
            'jsx', 'rescript', 'php', 'markdown', 'glimmer', 'handlebars', 'hbs'
        }
    },
    {
        'windwp/nvim-autopairs',
        event = { 'VeryLazy' },
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
}
