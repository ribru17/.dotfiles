-- bootstrap lazy plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- settings and autocmds must load before plugins,
-- but we can manually enable caching before both
-- of these for optimal performance
require('lazy.core.cache').enable()

-- load opt settings and auto commands
local settings = require('settings')
settings.apply()
require('autocmds')

-- load installed plugins and their configurations
require('lazy').setup('plugins', {
  -- defaults = { lazy = true },
  -- checker = { enabled = true },
  ui = {
    border = require('settings').border,
  },
  install = {
    colorscheme = { 'bamboo' },
  },
  change_detection = {
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      disabled_plugins = settings.unloaded_default_plugins,
    },
  },
  -- debug = true,
})
