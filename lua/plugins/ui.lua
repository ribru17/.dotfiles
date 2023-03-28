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
    }
}
