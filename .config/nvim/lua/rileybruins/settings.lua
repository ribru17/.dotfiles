local in_dotfiles = vim.fn.system(
  'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME ls-tree --name-only HEAD'
) ~= ''

local BORDER_STYLE = 'rounded'

local M = {
  border = BORDER_STYLE,
  in_dotfiles = in_dotfiles,
  hide_foldcolumn = { 'markdown', 'gitconfig', 'toml' },
  codelens_refresh_events = { 'InsertLeave', 'TextChanged', 'CursorHold' },
  ensure_installed_ts_parsers = {
    'bash',
    'c',
    'comment',
    'diff',
    'doxygen',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'haskell',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'latex',
    'lua',
    'luadoc',
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
  unloaded_default_plugins = {
    'gzip',
    'matchit',
    'matchparen',
    'netrwPlugin',
    'tarPlugin',
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
      'dropbar_menu',
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
      -- This is sadly super slow sometimes. Look into making it faster?
      query_lint_on = {},
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
      neovide_cursor_animate_in_insert_mode = false,
      matchup_matchparen_offscreen = {}, -- disable matchup statusline
      matchup_matchparen_deferred = 1, -- better cursor movement performance
    },
    o = {
      backup = false,
      compatible = false,
      cpoptions = 'aABceFs', -- make `cw` compatible with other `w` operations
      cursorline = true,
      cursorlineopt = 'number',
      diffopt = 'internal,filler,closeoff,linematch:90',
      encoding = 'utf-8',
      expandtab = true,
      fillchars = [[eob: ,fold: ,foldopen: ,foldsep: ,foldclose:▹]],
      foldcolumn = '1',
      foldenable = true,
      foldlevel = 99,
      foldlevelstart = 99,
      foldmethod = 'expr',
      guifont = 'Iosevka Custom Extended,Symbols Nerd Font Mono:h15',
      ignorecase = true,
      laststatus = 3,
      linespace = -1,
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
      tabstop = 8,
      termguicolors = true,
      textwidth = 80,
      tildeop = true,
      undodir = vim.env.HOME .. '/.vim/undodir',
      undofile = true,
      virtualedit = 'block',
      wrap = false,
    },
    wo = {
      foldtext = '',
    },
    opt = {
      completeopt = { 'menu', 'menuone', 'preview', 'noselect', 'noinsert' },
      listchars = { tab = '<->', nbsp = '␣', trail = '·' },
    },
    env = {
      GIT_WORK_TREE = in_dotfiles and vim.env.HOME or vim.env.GIT_WORK_TREE,
      GIT_DIR = in_dotfiles and vim.env.HOME .. '/.dotfiles' or vim.env.GIT_DIR,
      -- for constant paging in delta previews
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
  vim.filetype.add {
    filename = {
      -- recognize e.g. Github private keys as PEM files
      id_ed25519 = 'pem',
      -- properly recognize Git configuration for dotfiles
      ['~/.dotfiles/config'] = 'gitconfig',
    },
  }

  -- override `get_option` to allow for proper JSX/TSX commenting
  local get_option = vim.filetype.get_option
  local in_jsx = require('rileybruins.utils').in_jsx_tags
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.filetype.get_option = function(filetype, option)
    if option ~= 'commentstring' then
      return get_option(filetype, option)
    end
    if filetype == 'javascriptreact' or filetype == 'typescriptreact' then
      local line = vim.api.nvim_get_current_line()
      if in_jsx(false) or line:match('^%s-{/%*.-%*/}%s-$') then
        return '{/*%s*/}'
      end
    end
    return get_option(filetype, option)
  end
end

return M
