-- bootstrap lazy plugin managers
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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

require('vim._extui').enable {
  enable = true,
  msg = {
    target = 'msg',
    timeout = 5000,
  },
}

-- settings and autocmds must load before plugins,
-- but we can manually enable caching before both
-- of these for optimal performance
require('lazy.core.cache').enable()

-- load opt settings and auto commands
local SETTINGS = require('rileybruins.settings')
SETTINGS.apply()
require('rileybruins.autocmds')

-- add event aliases
local event = require('lazy.core.handler.event')
event.mappings.LazyFile =
  { id = 'LazyFile', event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' } }
event.mappings['User LazyFile'] = event.mappings.LazyFile

-- load installed plugins and their configurations
require('lazy').setup('plugins', {
  -- defaults = { lazy = true },
  -- checker = { enabled = true },
  ui = {
    -- TODO: Remove once https://github.com/folke/lazy.nvim/pull/1957 is merged
    border = vim.o.winborder,
    backdrop = 100,
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
      disabled_plugins = SETTINGS.unloaded_default_plugins,
    },
  },
  rocks = { enabled = false },
  -- debug = true,
})
