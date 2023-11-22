local function apply()
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
    },
    o = {
      backup = false,
      colorcolumn = '80',
      compatible = false,
      cursorline = true,
      cursorlineopt = 'number',
      encoding = 'utf-8',
      expandtab = true,
      filetype = 'on',
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
      wrap = false,
    },
    opt = {
      completeopt = { 'menu', 'menuone', 'preview', 'noselect', 'noinsert' },
      listchars = { tab = '<->', nbsp = '␣' },
    },
  }

  for scope, ops in pairs(settings) do
    for op_key, op_value in pairs(ops) do
      vim[scope][op_key] = op_value
    end
  end
end

return {
  border = 'rounded',
  apply = apply,
}
