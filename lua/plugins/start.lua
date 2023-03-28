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
        -- event = { 'VeryLazy' },
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
        'lewis6991/gitsigns.nvim',
        event = { 'VeryLazy' },
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
        'tpope/vim-abolish',
        event = { 'VeryLazy' },
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        event = { 'VeryLazy' },
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
}
