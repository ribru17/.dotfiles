-- specify different tab widths on certain files
vim.api.nvim_create_augroup('setIndent', { clear = true })
vim.api.nvim_create_autocmd('Filetype', {
    group = 'setIndent',
    pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
        'yaml', 'javascriptreact', 'typescriptreact', 'markdown', 'lua'
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

-- lazy load keymaps and user-defined commands
vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("LoadBinds", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
        require('bindings')
    end,
})

-- load EZ-Semicolon upon entering insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    group = vim.api.nvim_create_augroup("LoadEZSemicolon", { clear = true }),
    -- pattern = "VeryLazy",
    callback = function()
        require('ezsemicolon')
        vim.api.nvim_clear_autocmds({ group = "LoadEZSemicolon" })
    end,
})
