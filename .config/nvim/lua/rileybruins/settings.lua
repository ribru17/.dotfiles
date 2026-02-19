local in_dotfiles = vim.fn.system(
  'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME ls-tree --name-only HEAD'
) ~= ''
local api = vim.api

local M = {
  in_dotfiles = in_dotfiles,
  hide_foldcolumn = { 'markdown', 'git_config', 'toml' },
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
  disabled_highlighting_fts = {
    'csv', -- get nice rainbow syntax
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
    'json',
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
}

local error = vim.diagnostic.severity.ERROR
local warn = vim.diagnostic.severity.WARN
local hint = vim.diagnostic.severity.HINT
local info = vim.diagnostic.severity.INFO

M.statusline = function()
  local ft = vim.bo.ft
  if ft == 'alpha' then
    return '%#Normal#'
  end

  local icon, hl = require('mini.icons').get('filetype', ft)
  local git_summary = vim.b.gitsigns_status_dict or {}
  local diags = vim.diagnostic.count(0)
  return string.format(
    '%%#MiniStatuslineModeNormal# %%t %%#DiagnosticOk#%%##%s%s%s%s %s%s%s%s %%= %%#%s#%s %%##%s %%#DiagnosticOk#%%#MiniStatuslineModeNormal# %%l/%%L:%%c ',
    git_summary.head and '  ' .. git_summary.head or '',
    git_summary.added
        and git_summary.added > 0
        and string.format(' %%#DiffAdded#+%s%%##', git_summary.added)
      or '',
    git_summary.changed
        and git_summary.changed > 0
        and string.format(' %%#DiffChanged#~%s%%##', git_summary.changed)
      or '',
    git_summary.removed
        and git_summary.removed > 0
        and string.format(' %%#DiffRemoved#-%s%%##', git_summary.removed)
      or '',
    diags[error]
        and string.format(' %%#DiagnosticError# %s%%##', diags[error])
      or '',
    diags[warn] and string.format(' %%#DiagnosticWarn# %s%%##', diags[warn])
      or '',
    diags[info] and string.format(' %%#DiagnosticInfo# %s%%##', diags[info])
      or '',
    diags[hint] and string.format(' %%#DiagnosticHint#󰛩 %s%%##', diags[hint])
      or '',
    hl,
    icon,
    ft
  )
end

M.tabline = function()
  local cur_tab = api.nvim_get_current_tabpage()
  local all_tabs = api.nvim_list_tabpages()
  local s = ''
  for _, tab in ipairs(all_tabs) do
    local mod = tab == cur_tab and 'TabLineSel' or 'TabLine'
    s = s .. string.format('%%#%s#%%$TabLineEdge$%%#%s#   ', mod, mod)
    local win = api.nvim_tabpage_get_win(tab)
    local buf = api.nvim_win_get_buf(win)
    local name = api.nvim_buf_get_name(buf)
    if name:len() == 0 then
      name = '[No Name]'
    end
    local ft = vim.bo[buf].ft
    if ft:len() > 0 then
      local icon, hl = require('mini.icons').get('filetype', ft)
      s = s .. string.format('%%$%s$%s %%#%s#', hl, icon, mod)
    end
    s = s .. vim.fs.basename(name)
    local diags = vim.diagnostic.count(buf)
    local worst_diag = diags[error] and '%$DiagnosticError$  '
      or diags[warn] and '%$DiagnosticWarn$  '
      or diags[info] and '%$DiagnosticInfo$  '
      or diags[hint] and '%$DiagnosticHint$ 󰛩 '
      or ''
    local diag_sum = (diags[error] or 0)
      + (diags[warn] or 0)
      + (diags[info] or 0)
      + (diags[hint] or 0)

    s = s .. worst_diag .. (diag_sum > 0 and diag_sum or '')

    if api.nvim_get_option_value('modified', { buf = buf }) then
      s = s .. ' %$DiagnosticOk$• '
    else
      s = s .. '   '
    end
    s = s .. '%$TabLineEdge$'
  end
  s = s .. '%#TabLineFill#%T'
  return s
end

M.apply = function()
  local settings = {
    g = {
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
      fillchars = [[eob: ,fold: ,foldopen: ,foldsep: ,foldclose:▹,diff:╱]],
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
      pumborder = 'rounded',
      pumheight = 10,
      redrawtime = 10000,
      relativenumber = true,
      scrolloff = 8,
      shiftwidth = 4,
      showtabline = 2,
      sidescrolloff = 5,
      signcolumn = 'number',
      smartcase = true,
      softtabstop = 4,
      splitright = true,
      statusline = "%!v:lua.require'rileybruins.settings'.statusline()",
      swapfile = false,
      tabline = "%!v:lua.require'rileybruins.settings'.tabline()",
      tabstop = 8,
      termguicolors = true,
      textwidth = 80,
      tildeop = true,
      undodir = vim.env.HOME .. '/.vim/undodir',
      undofile = true,
      virtualedit = 'block',
      winborder = 'rounded',
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

  -- we will only enable syntax for certain buffers later
  vim.cmd.syntax('manual')
end

return M
