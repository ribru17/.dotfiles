return {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup {
                integrations = {
                    indent_blankline = {
                        enabled = true,
                        colored_indent_levels = true,
                    }
                }
            }
            vim.cmd.colorscheme "catppuccin"
        end
    },
    {
        'akinsho/bufferline.nvim',
        event = { 'VeryLazy' },
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
    {
        'nvim-lualine/lualine.nvim',
        event = { 'VeryLazy' },
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
    {
        'kyazdani42/nvim-web-devicons',
        lazy = true
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
}