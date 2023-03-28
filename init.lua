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
        'yaml', 'javascriptreact', 'typescriptreact', 'markdown'
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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    --defaults = { lazy = true },
    --checker = { enabled = true },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    -- debug = true,
})

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

-- Make comment work on terminals where C-/ is literally C-/
vim.keymap.set('n', '<C-/>', '<C-_>', { remap = true })
vim.keymap.set('v', '<C-/>', '<C-_>', { remap = true })
vim.keymap.set('i', '<C-/>', '<C-_>', { remap = true })

vim.cmd.colorscheme "catppuccin"

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
    return firstFour == 'for ' or firstFour == 'for('
end

local function isInReturn(s)
    local firstSeven = string.sub(trimBeg(s), 1, 7)
    return firstSeven == 'return ' or firstSeven == 'return' or firstSeven == 'return;'
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
vim.keymap.set("n", "<leader>dq", 'dsq', { remap = true })
vim.keymap.set("n", "<leader>dp", 'ds(', { remap = true })
vim.keymap.set("n", "<leader>db", 'dsb', { remap = true })
vim.keymap.set("n", "<leader>dd", 'dsd', { remap = true })

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
vim.keymap.set('i', '<C-w>', '<C-Right>', { remap = false })
vim.keymap.set('i', '<C-b>', '<C-Left>', { remap = false })

-- command mode navigation
vim.keymap.set('c', '<C-k>', '<Up>', { remap = false })
vim.keymap.set('c', '<C-h>', '<Left>', { remap = false })
vim.keymap.set('c', '<C-j>', '<Down>', { remap = false })
vim.keymap.set('c', '<C-l>', '<Right>', { remap = false })

-- quicker than hitting esc?
vim.keymap.set('i', '<M-i>', '<Esc>', { remap = false })

vim.keymap.set('i', '<M-BS>', '<C-w>', { remap = false })

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
