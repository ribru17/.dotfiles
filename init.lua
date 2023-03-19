vim.opt.compatible = false
vim.opt.encoding = "utf-8"
vim.opt.filetype = "on"
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 5
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.completeopt = { 'menu', 'menuone', 'preview', 'noselect', 'noinsert' }
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.ignorecase = true
vim.opt.colorcolumn = "80"
vim.opt.termguicolors = true
vim.opt.mouse = ""

vim.g.mapleader = " "
vim.g.mkdp_echo_preview_url = 1
vim.g.rustfmt_autosave = 1

-- specify different tab widths on certain files
vim.api.nvim_create_augroup('setIndent', { clear = true })
vim.api.nvim_create_autocmd('Filetype', {
    group = 'setIndent',
    pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
        'yaml', 'javascriptreact', 'typescriptreact'
    },
    command = 'setlocal shiftwidth=2 tabstop=2 softtabstop=2'
})

-- where applicable, reset cursor to blinking I-beam after closing Neovim
-- https://github.com/neovim/neovim/issues/4867
vim.api.nvim_create_augroup('resetCursor', { clear = true })
vim.api.nvim_create_autocmd('VimLeave', {
    group = 'resetCursor',
    pattern = '*',
    command = 'set guicursor=a:ver10-blinkon1'
})

-- prevent comment from being inserted when entering new line in existing comment
vim.api.nvim_create_autocmd("BufEnter",
    { callback = function() vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" } end, })

local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug 'windwp/nvim-autopairs'
Plug 'rust-lang/rust.vim'

-- Faster highlight updates
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = 'TSUpdate' })

-- Color scheme
Plug('catppuccin/nvim', { as = 'catppuccin' })

-- Searching files easier
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })

-- :Git ~something~ commands to make git easier
Plug 'tpope/vim-fugitive'

-- LSP Support
Plug 'neovim/nvim-lspconfig'             -- Required
Plug 'williamboman/mason.nvim'           -- Optional
Plug 'williamboman/mason-lspconfig.nvim' -- Optional

-- Autocompletion Engine
Plug 'hrsh7th/nvim-cmp'         -- Required
Plug 'hrsh7th/cmp-nvim-lsp'     -- Required
Plug 'hrsh7th/cmp-buffer'       -- Optional
Plug 'hrsh7th/cmp-path'         -- Optional
Plug 'saadparwaiz1/cmp_luasnip' -- Optional
Plug 'hrsh7th/cmp-nvim-lua'     -- Optional

-- Snippets
Plug 'L3MON4D3/LuaSnip' -- Required

-- LSP
Plug('VonHeikemen/lsp-zero.nvim', { branch = 'v1.x' })

-- Toggle comments
Plug 'numToStr/Comment.nvim'

-- Markdown Preview, use :MarkdownPreview
Plug('iamcco/markdown-preview.nvim', {
    ['do'] = function()
        vim.call('mkdp#util#install')
    end,
    ['for'] = { 'markdown', 'vim-plug' }
})

-- Surround
Plug 'kylechui/nvim-surround'

-- Cool statusline
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

-- Cool bufferline
Plug 'akinsho/bufferline.nvim'

-- HTML-Style tag completion
Plug 'windwp/nvim-ts-autotag'

-- Show git diff line markers
Plug 'lewis6991/gitsigns.nvim'

-- Configure formatters
Plug 'jose-elias-alvarez/null-ls.nvim'

-- Case matching text replace
Plug 'tpope/vim-abolish'

-- Indent lines
Plug 'lukas-reineke/indent-blankline.nvim'

vim.call('plug#end')

require('nvim-autopairs').setup {}

local null_ls = require("null-ls")

local lsp_formatting = function()
    vim.lsp.buf.format({
        filter = function(client)
            -- use clang_format instead for more granular control via null-ls
            -- this makes it so we can still use clangd as an LSP (yay!)
            return client.name ~= "clangd"
        end,
    })
end

-- Explicitly format on save: passing this through null-ls failed with
-- unsupported formatters, e.g. html-lsp
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { '*.xml', '*.html', '*.xhtml', '*.css', '*.scss', '*.js', '*.ts',
        '*.yaml', '*.jsx', '*.tsx', '*.md', '*.mdx', '*.lua', '*.c', '*.cpp'
    },
    callback = function()
        lsp_formatting()
    end
})

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

require("catppuccin").setup {
    integrations = {
        indent_blankline = {
            enabled = true,
            colored_indent_levels = true,
        }
    }
}

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

-- Insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

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

require('nvim-surround').setup {
    aliases = {
        ["d"] = { "{", "[", "(", "<", '"', "'", "`" }, -- any delimiter
        ["b"] = { "{", "[", "(", "<" },                -- bracket
    }
}

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

        -- git preview, git blame
        map('n', '<leader>gp', gs.preview_hunk)
        map('n', '<leader>gb', function() gs.blame_line { full = true } end)
    end,
})

require 'nvim-treesitter.configs'.setup {
    -- HTML-style tag completion
    autotag = {
        enable = true,
    },
    indent = {
        enable = true
    }
}

-- Make comment work on terminals where C-/ is literally C-/
vim.keymap.set('n', '<C-/>', '<C-_>', { remap = true })
vim.keymap.set('v', '<C-/>', '<C-_>', { remap = true })
vim.keymap.set('i', '<C-/>', '<C-_>', { remap = true })

require('Comment').setup({
    toggler = {
        line = '<C-_>',
    },
    opleader = {
        line = '<C-_>'
    },
})

vim.cmd.colorscheme "catppuccin"

local actions = require('telescope.actions')
require("telescope").setup({
    defaults = {
        layout_config = {
            horizontal = {
                preview_cutoff = 0,
            },
        },
        initial_mode = "normal",
        mappings = {
            n = {
                ["<Tab>"] = actions.select_tab -- <Tab> to open as tab
            },
            i = {
                ["<Tab>"] = actions.select_tab -- <Tab> to open as tab
            }
        }
    },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function()
    builtin.find_files {
        find_command = function()
            return { 'rg', '--files', '-g', '!' .. string.gsub(vim.api.nvim_buf_get_name(0), vim.loop.cwd(), '') }
        end
    }
end
, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>sf', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, {})

local lsp = require('lsp-zero')

lsp.preset('recommended')

-- Suppress irritating `undefined global vim` errors
lsp.nvim_workspace()

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
-- supertab functionality
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local luasnip = require('luasnip')
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
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
        fields = { 'menu', 'abbr', 'kind' },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = '󰆧',
                luasnip = '󰘖',
                buffer = '',
                path = '',
            }

            item.menu = menu_icon[entry.source.name]
            return item
        end,
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

--> BEGINNING OF EZ SEMICOLON VIM EDITION <--

local function trim(s)
    return s:gsub("^%s+", ""):gsub("%s+$", "")
end

local function trimBeg(s)
    return s:gsub("^%s+", "")
end

local function isInFor(s)
    local firstFour = string.sub(trimBeg(s), 1, 4)
    if firstFour == 'for ' or firstFour == 'for(' then
        return true
    else
        return false
    end
end

local function isInReturn(s)
    local firstSeven = string.sub(trimBeg(s), 1, 7)
    if firstSeven == 'return ' or firstSeven == 'return' or firstSeven == 'return;' then
        return true
    else
        return false
    end
end

vim.keymap.set('i', ';', function()
    local line = vim.api.nvim_get_current_line()
    local last = string.sub(trim(line), -1)
    if isInFor(line) then
        return ';'
    end
    if isInReturn(line) then
        if last == ';' then
            return '<esc>g_'
        else
            return '<esc>g_a;<esc>'
        end
    end
    if last == ';' then
        return '<esc>$a<cr>'
    else
        if string.len(trim(line)) == 0 then
            return ';<esc>==$a<cr>'
        end
        return '<esc>g_a;<cr>'
    end
end, { expr = true })
vim.keymap.set('i', '<M-;>', ';', { remap = false })

--> END OF EZ SEMICOLON VIM EDITION <--

--> MISCELLANEOUS KEYMAPS <--

-- VSCode style block indentation
vim.keymap.set("x", "<Tab>", ">", { remap = false })
vim.keymap.set("x", "<S-Tab>", "<", { remap = false })
vim.keymap.set("n", "<Tab>", ">>", { remap = false })
vim.keymap.set("n", "<S-Tab>", "<<", { remap = false })

-- move selected code blocks smartly with
-- indenting for if statements and such
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

-- easily move cursor selection backwards
vim.keymap.set("x", "H", "oho", { remap = false })
vim.keymap.set("x", "L", "olo", { remap = false })

-- keep cursor in place
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- surround visual selection
vim.keymap.set("x", "(", "S(", { remap = true })
vim.keymap.set("x", ")", "S)", { remap = true })
vim.keymap.set("x", "{", "S{", { remap = true })
vim.keymap.set("x", "}", "S}", { remap = true })
vim.keymap.set("x", "'", "S'", { remap = true })
vim.keymap.set("x", '"', 'S"', { remap = true })
vim.keymap.set("x", "`", "S`", { remap = true })
vim.keymap.set("x", "<", "S<", { remap = true })
vim.keymap.set("x", ">", "S>", { remap = true })
vim.keymap.set("x", "T", "ST", { remap = true })
vim.keymap.set("x", "[[", "S[", { remap = true })
vim.keymap.set("x", "]]", "S]", { remap = true })

-- clear search highlighting
vim.keymap.set("n", "<Esc>", ":noh<CR>")

-- don't enter ex mode(?) by accident
vim.keymap.set("n", "Q", "<nop>")

-- replace instances of hovered word
vim.keymap.set("n", "<leader>h", ":%S/<C-r><C-w>/<C-r><C-w>/gcw<Left><Left><Left><Left>")
vim.keymap.set("n", "<leader>H", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gIc<Left><Left><Left><Left>")

-- toggle comment in insert mode
vim.keymap.set("i", "<C-_>", function()
    local api = require('Comment.api')
    api.toggle.linewise.current()
    vim.cmd('normal! $')
    vim.cmd([[startinsert!]])
end, {})

-- change current HTML-style tags
vim.keymap.set("n", "<leader>cht", "cst", { remap = true })
-- delete current HTML-style tags
vim.keymap.set("n", "<leader>dht", "dst", { remap = true })
-- delete surrounding delimiters
-- view is marked and loaded to prevent disorienting scrolling behavior:
-- https://github.com/kylechui/nvim-surround/issues/149
vim.keymap.set("n", "<leader>dq", '<Cmd>mkview<CR>dsq<Cmd>loadview<CR>', { remap = true })
vim.keymap.set("n", "<leader>dp", '<Cmd>mkview<CR>ds(<Cmd>loadview<CR>', { remap = true })
vim.keymap.set("n", "<leader>db", '<Cmd>mkview<CR>dsb<Cmd>loadview<CR>', { remap = true })
vim.keymap.set("n", "<leader>dd", '<Cmd>mkview<CR>dsd<Cmd>loadview<CR>', { remap = true })

-- cycle through tabs (reversing order for more intuitive UX)
vim.keymap.set('n', '<C-n>', '<Cmd>BufferLineCyclePrev<CR>', {})
vim.keymap.set('n', '<C-p>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<C-l>', '<Cmd>tabmove +1<CR>', {})
vim.keymap.set('n', '<C-h>', '<Cmd>tabmove -1<CR>', {})

-- copy/cut to clipboard (Linux)
vim.keymap.set('v', '<C-y>', '"+y', { remap = false })
vim.keymap.set('v', '<C-x>', '"+x', { remap = false })

-- insert mode navigation
vim.keymap.set('i', '<C-k>', '<Up>', { remap = false })
vim.keymap.set('i', '<C-h>', '<Left>', { remap = false })
vim.keymap.set('i', '<C-j>', '<Down>', { remap = false })
vim.keymap.set('i', '<C-l>', '<Right>', { remap = false })

-- command mode navigation
vim.keymap.set('c', '<C-k>', '<Up>', { remap = false })
vim.keymap.set('c', '<C-h>', '<Left>', { remap = false })
vim.keymap.set('c', '<C-j>', '<Down>', { remap = false })
vim.keymap.set('c', '<C-l>', '<Right>', { remap = false })

-- quicker than hitting esc?
vim.keymap.set('i', '<M-i>', '<Esc>', { remap = false })

--> END OF MISCELLANEOUS KEYMAPS <--

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--> MISCELLANEOUS USER COMMANDS <--

-- write without formatting
vim.api.nvim_create_user_command('W', 'noa w', {})
vim.api.nvim_create_user_command('Wq', 'noa w | q', {})
vim.api.nvim_create_user_command('Wa', 'noa wa', {})
vim.api.nvim_create_user_command('Wqa', 'noa wa | qa', {})
vim.api.nvim_create_user_command('Wn', 'noa wn', {})
vim.api.nvim_create_user_command('WN', 'noa wN', {})
vim.api.nvim_create_user_command('Wp', 'noa wp', {})

--> END OF MISCELLANEOUS USER COMMANDS <--

require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the four first parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "help", "javascript", "typescript", "rust", "tsx" },

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
}

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
