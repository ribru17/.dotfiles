vim.opt.compatible = false
vim.opt.encoding="utf-8"
vim.opt.signcolumn="yes"
vim.opt.scrolloff=8
vim.opt.sidescrolloff=5
vim.opt.number = true
vim.opt.tabstop=4
vim.opt.softtabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.completeopt = {'menu', 'menuone', 'preview', 'noselect', 'noinsert'}
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.ignorecase = true
vim.opt.colorcolumn = "80"
vim.g.mapleader = " "

local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug 'jiangmiao/auto-pairs'
Plug 'rust-lang/rust.vim'
-- Plug('neoclide/coc.nvim', {branch = 'release'})
-- Plug 'dense-analysis/ale'

-- faster highlight updates
Plug('nvim-treesitter/nvim-treesitter', {run = 'TSUpdate'})
-- color scheme
Plug('catppuccin/nvim', { as = 'catppuccin' })
-- searching files easier
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', { tag = '0.1.1' })
-- this is for :Git ~something~ commands to make git easier
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
Plug 'L3MON4D3/LuaSnip'             -- Required
Plug 'rafamadriz/friendly-snippets' -- Optional

Plug('VonHeikemen/lsp-zero.nvim', {branch = 'v1.x'})

-- Toggle comments
Plug 'numToStr/Comment.nvim'

vim.call('plug#end')

require('Comment').setup({
    toggler = {
        line = '<C-_>'
    },
    opleader = {
        line = '<C-_>'
    }
})

vim.cmd.colorscheme "catppuccin"
vim.g.rustfmt_autosave = 1

require("telescope").setup({
    defaults = {
        layout_config = {
            horizontal = {
                preview_cutoff = 0,
            },
        },
        initial_mode = "normal"
    },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>sf', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, {})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {})

local lsp = require('lsp-zero')

lsp.preset('recommended')

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local luasnip = require('luasnip')
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.confirm { select = true }
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

-- suppress irritating undefined global vim warnings
lsp.configure('sumneko_lua', {
    settings = {
        Lua = {
            diagnostics = { globals = {'vim'} }
        }
    }
})

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
            return '<esc>$'
        else
            return '<esc>g_a;<esc>'
    	end
    end
    if last == ';' then
        return '<esc>$a<cr>'
    else
        return '<esc>g_a;<cr>'
    end
end, {expr = true})
vim.keymap.set('i', '<M-;>', ';', {remap = false})

--> END OF EZ SEMICOLON VIM EDITION <--

--> MISCELLANEOUS KEYMAPS <--
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { buffer = bufnr, remap = false })
vim.keymap.set("x", "<Tab>", ">", {remap = false})
vim.keymap.set("x", "<S-Tab>", "<", {remap = false})

-- move selected code blocks smartly with
-- indenting for if statements and such
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor in place 
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- clear search highlighting
vim.keymap.set("n", "<Esc>", ":noh<CR>")

-- don't enter ex mode(?) by accident
vim.keymap.set("n", "Q", "<nop>")

-- replace instances of hovered word
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- comment in insert mode
function mysplit (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

-- toggle comment in insert mode
vim.keymap.set("i", "<C-_>", function()
    local api = require('Comment.api')
    api.toggle.linewise.current()
    vim.cmd('normal! $')
    vim.cmd([[startinsert!]])
end, {})

--> END OF MISCELLANEOUS KEYMAPS <--

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "help", "javascript", "typescript", "rust" },

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
