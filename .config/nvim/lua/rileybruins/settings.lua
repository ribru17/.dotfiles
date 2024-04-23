local in_dotfiles = vim.fn.system(
  'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME ls-tree --name-only HEAD'
) ~= ''

local BORDER_STYLE = 'rounded'
local telescope_border_chars = {
  none = { '', '', '', '', '', '', '', '' },
  single = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  double = { '═', '║', '═', '║', '╔', '╗', '╝', '╚' },
  rounded = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  solid = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  shadow = { '', '', '', '', '', '', '', '' },
}
local connected_telescope_border_chars = {
  none = { '', '', '', '', '', '', '', '' },
  single = { '─', '│', '─', '│', '┌', '┐', '┤', '├' },
  double = { '═', '║', '═', '║', '╔', '╗', '╣', '╠' },
  rounded = { '─', '│', '─', '│', '╭', '╮', '┤', '├' },
  solid = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  shadow = { '', '', '', '', '', '', '', '' },
}

local M = {
  border = BORDER_STYLE,
  telescope_border_chars = telescope_border_chars[BORDER_STYLE],
  telescope_centered_picker = {
    results_title = false,
    layout_strategy = 'center',
    layout_config = {
      anchor = 'S',
      preview_cutoff = 1,
      prompt_position = 'bottom',
      width = 0.95,
      results_height = 5,
    },
    border = true,
    borderchars = {
      prompt = telescope_border_chars[BORDER_STYLE],
      results = connected_telescope_border_chars[BORDER_STYLE],
      preview = telescope_border_chars[BORDER_STYLE],
    },
  },
  in_dotfiles = in_dotfiles,
  -- If `true`, this consumes a lot of resources and slows the LSP greatly.
  luals_load_plugins = false,
  hide_foldcolumn = { 'markdown', 'gitconfig', 'toml' },
  codelens_refresh_events = { 'InsertLeave', 'TextChanged', 'CursorHold' },
  lazy_loaded_colorschemes = {
    'catppuccin',
    'tokyonight',
    'onedark',
    'kanagawa',
  },
  ensure_installed_ts_parsers = {
    'bash',
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
    'printf',
    'query',
    'regex',
    'rust',
    'sql',
    'styled',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'xml',
  },
  ensure_installed_lsps = {
    'bashls',
    'clangd',
    'cssls',
    'denols',
    'emmet_language_server',
    'eslint',
    'gopls',
    'lua_ls',
    'marksman',
    'pylsp',
    'tsserver',
  },
  ensure_installed_formatters = {
    'clang-format',
    'prettierd',
    'shellcheck',
    'shfmt',
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
    'css',
    'html',
    'javascript',
    'javascriptreact',
    'lua',
    'markdown',
    'nix',
    'query',
    'r',
    'scss',
    'typescript',
    'typescriptreact',
    'xhtml',
    'xml',
    'yaml',
  },
  mini_indent_scope = {
    ignore_bottom_whitespace = {
      'gitconfig',
      'markdown',
      'python',
      'query',
      'scheme',
    },
    disabled = {
      'NeogitPopup',
      'NeogitStatus',
      'NvimTree',
      'TelescopePrompt',
      'TelescopeResults',
      'alpha',
      'checkhealth',
      'fzf',
      'gitcommit',
      'gitconfig',
      'help',
      'lazy',
      'lspinfo',
      'make',
      'man',
      'mason',
      'qf',
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
      cpoptions = 'aABceFs', -- make `cw` compatible with other `w` operations
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
      signcolumn = 'number',
      smartcase = true,
      softtabstop = 4,
      splitright = true,
      swapfile = false,
      tabstop = 4,
      termguicolors = true,
      textwidth = 80,
      undodir = vim.env.HOME .. '/.vim/undodir',
      undofile = true,
      virtualedit = 'block,insert',
      wrap = false,
    },
    opt = {
      completeopt = { 'menu', 'menuone', 'preview', 'noselect', 'noinsert' },
      listchars = { tab = '<->', nbsp = '␣' },
    },
    env = {
      GIT_WORK_TREE = in_dotfiles and vim.env.HOME or vim.env.GIT_WORK_TREE,
      GIT_DIR = in_dotfiles and vim.env.HOME .. '/.dotfiles' or vim.env.GIT_DIR,
      -- for constant paging in Telescope delta commands
      GIT_PAGER = 'delta --paging=always',
    },
  }

  -- apply the above settings
  for scope, ops in pairs(settings) do
    local op_group = vim[scope]
    for op_key, op_value in pairs(ops) do
      op_group[op_key] = op_value
    end
  end

  -- properly recognize more filetypes
  -- TODO: Remove conf and luau specifications after a future Neovim version
  vim.filetype.add {
    extension = {
      conf = 'conf',
      luau = 'luau',
    },
    filename = {
      -- recognize e.g. Github private keys as PEM files
      id_ed25519 = 'pem',
      -- properly recognize Git configuration for dotfiles
      ['~/.dotfiles/config'] = 'gitconfig',
    },
  }
end

return M
