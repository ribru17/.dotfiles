local Pkg = require('mason-core.package')
local pip3 = require('mason-core.managers.pip3')

-- Override the default `python-lsp-server` Mason entry with a minimal version
-- that does not install all of the optional plugins.
return Pkg.new {
  name = 'python-lsp-server',
  desc = [[Fork of the python-language-server project, maintained by the Spyder IDE team and the community]],
  homepage = 'https://github.com/python-lsp/python-lsp-server',
  categories = { Pkg.Cat.LSP },
  languages = { Pkg.Lang.Python },
  install = pip3.packages { 'python-lsp-server', bin = { 'pylsp' } },
}
