local function apply()
  local opt = vim.opt
  local o = vim.o
  local g = vim.g

  opt.compatible = false
  opt.encoding = 'utf-8'
  opt.filetype = 'on'
  opt.signcolumn = 'yes:2'
  opt.scrolloff = 8
  opt.sidescrolloff = 5
  opt.number = true
  opt.tabstop = 4
  opt.softtabstop = 4
  opt.shiftwidth = 4
  opt.expandtab = true
  opt.completeopt = { 'menu', 'menuone', 'preview', 'noselect', 'noinsert' }
  opt.wrap = false
  opt.swapfile = false
  opt.backup = false
  opt.undofile = true
  opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
  opt.ignorecase = true
  opt.smartcase = true
  opt.termguicolors = true
  opt.mouse = ''
  opt.pumheight = 10
  opt.relativenumber = true
  opt.colorcolumn = '80'
  opt.textwidth = 80
  opt.splitright = true
  opt.cursorline = true
  opt.cursorlineopt = 'number'
  opt.foldenable = true
  opt.foldmethod = 'expr'
  opt.list = true
  opt.listchars = { tab = '<->', nbsp = '␣' }
  opt.indentkeys:append('!0<Tab>')
  o.foldcolumn = '1'
  o.fillchars = [[eob: ,fold: ,foldopen:▽,foldsep: ,foldclose:▷]]
  o.foldlevel = 99
  o.foldlevelstart = 99

  g.mapleader = ' '
  g.mkdp_echo_preview_url = 1
  g.mkdp_theme = 'dark'
  g.mkdp_preview_options = {
    maid = {
      theme = 'dark',
    },
  }
  g.rustfmt_autosave = 1
  g.bullets_outline_levels = { 'ROM', 'ABC', 'rom', 'abc', 'std-' }
  g.bullets_checkbox_markers = ' x'
end

return {
  border = 'rounded',
  apply = apply,
}
