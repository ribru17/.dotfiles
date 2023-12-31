local M = {
  border = 'rounded',
  -- If `true`, this consumes a lot of resources and slows the LSP greatly.
  luals_load_plugins = false,
  hide_foldcolumn = { 'markdown', 'text' },
  codelens_refresh_events = { 'InsertLeave', 'TextChanged', 'CursorHold' },
  lazy_loaded_colorschemes = {
    'catppuccin',
    'tokyonight',
    'onedark',
    'kanagawa',
  },
  ensure_installed_ts_parsers = {
    'c',
    'comment',
    'diff',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'haskell',
    'html',
    'javascript',
    'json',
    'latex',
    'lua',
    'luap',
    'markdown',
    'markdown_inline',
    'mermaid',
    'query',
    'regex',
    'rust',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
  },
  ensure_installed_lsps = {
    'clangd',
    'cssls',
    'denols',
    'emmet_language_server',
    'eslint',
    'gopls',
    'lua_ls',
    'marksman',
    'pylsp',
  },
  ensure_installed_formatters = {
    'clang-format',
    'prettierd',
    'stylua',
    'yapf',
  },
  unloaded_default_plugins = {
    'gzip',
    'matchit',
    'matchparen',
    'netrwPlugin',
    'tarPlugin',
    'tohtml',
    'tutor',
    'zipPlugin',
  },
  two_space_indents = {
    'xml',
    'html',
    'xhtml',
    'css',
    'scss',
    'javascript',
    'typescript',
    'yaml',
    'javascriptreact',
    'typescriptreact',
    'markdown',
    'lua',
  },
  mini_indent_scope = {
    ignore_bottom_whitespace = { 'python', 'markdown', 'scheme', 'query' },
    disabled = {
      'alpha',
      'lazy',
      'mason',
      'lspinfo',
      'help',
      'checkhealth',
      'man',
      'make',
      'gitcommit',
      'TelescopePrompt',
      'TelescopeResults',
      'NvimTree',
      'NeogitPopup',
      'NeogitStatus',
    },
  },
}

M.apply = function()
  local settings = {
    g = {
      bullets_checkbox_markers = ' x',
      bullets_outline_levels = { 'ROM', 'ABC', 'rom', 'abc', 'std-' },
      mapleader = ' ',
      mkdp_echo_preview_url = 1,
      mkdp_preview_options = {
        maid = {
          theme = 'dark',
        },
      },
      mkdp_theme = 'dark',
      rustfmt_autosave = 1,
      haskell_tools = {
        tools = {
          codeLens = {
            -- we already set up this autocmd ourselves
            autoRefresh = false,
          },
        },
      },
      -- Recognize `.typ` filetype as `typst`. Only works on nightly as of now.
      filetype_typ = 'typst',
    },
    o = {
      backup = false,
      colorcolumn = '80',
      compatible = false,
      cursorline = true,
      cursorlineopt = 'number',
      encoding = 'utf-8',
      expandtab = true,
      fillchars = [[eob: ,fold: ,foldopen:▽,foldsep: ,foldclose:▷]],
      foldcolumn = '1',
      foldenable = true,
      foldlevel = 99,
      foldlevelstart = 99,
      foldmethod = 'expr',
      ignorecase = true,
      list = true,
      mouse = '',
      number = true,
      pumheight = 10,
      relativenumber = true,
      scrolloff = 8,
      shiftwidth = 4,
      sidescrolloff = 5,
      signcolumn = 'yes:2',
      smartcase = true,
      softtabstop = 4,
      splitright = true,
      swapfile = false,
      tabstop = 4,
      termguicolors = true,
      textwidth = 80,
      undodir = os.getenv('HOME') .. '/.vim/undodir',
      undofile = true,
      virtualedit = 'block',
      wrap = false,
    },
    opt = {
      completeopt = { 'menu', 'menuone', 'preview', 'noselect', 'noinsert' },
      listchars = { tab = '<->', nbsp = '␣' },
    },
  }

  for scope, ops in pairs(settings) do
    local op_group = vim[scope]
    for op_key, op_value in pairs(ops) do
      op_group[op_key] = op_value
    end
  end

  -- properly recognize more filetypes
  -- TODO: Remove after a future Neovim version
  vim.filetype.add {
    extension = {
      conf = 'conf',
      luau = 'luau',
    },
  }
end

return M
