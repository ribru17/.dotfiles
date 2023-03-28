return {
    {
        'rust-lang/rust.vim',
        ft = 'rust',
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'VeryLazy' },
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
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        keys = {
            { '<leader>ff' },
            { '<leader>sf' },
            { '<leader>gf' },
        },
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
}
