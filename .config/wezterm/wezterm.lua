local wezterm = require('wezterm')
local act = wezterm.action
local mux = wezterm.mux

local SCHEME_OBJ = wezterm.get_builtin_color_schemes()['Bamboo']

wezterm.on('gui-startup', function()
  local _, _, window = mux.spawn_window {}
  window:gui_window():maximize()
end)

local SOLID_LEFT_CIRC = wezterm.nerdfonts.ple_left_half_circle_thick
local SOLID_RIGHT_CIRC = wezterm.nerdfonts.ple_right_half_circle_thick
local tab_bg = SCHEME_OBJ.tab_bar.background
local bg = SCHEME_OBJ.tab_bar.active_tab.bg_color
local i_bg = SCHEME_OBJ.tab_bar.inactive_tab.bg_color
local ih_bg = SCHEME_OBJ.tab_bar.inactive_tab_hover.bg_color

wezterm.on('format-tab-title', function(tab, _, _, _, hover, max_width)
  local title = tab.tab_index + 1
    .. ': '
    .. os.getenv('USER')
    .. '@'
    .. wezterm.hostname()
  title = wezterm.truncate_right(title, max_width - 2)

  if tab.is_active then
    return wezterm.format {
      { Foreground = { Color = bg } },
      { Background = { Color = tab_bg } },
      { Text = SOLID_LEFT_CIRC },
      'ResetAttributes',
      { Text = title },
      { Foreground = { Color = bg } },
      { Background = { Color = tab_bg } },
      { Text = SOLID_RIGHT_CIRC },
    }
  end
  return wezterm.format {
    { Foreground = { Color = hover and ih_bg or i_bg } },
    { Background = { Color = tab_bg } },
    { Text = SOLID_LEFT_CIRC },
    'ResetAttributes',
    { Text = title },
    { Foreground = { Color = hover and ih_bg or i_bg } },
    { Background = { Color = tab_bg } },
    { Text = SOLID_RIGHT_CIRC },
  }
end)

return {
  -- font options
  -- NOTE: if nerd font symbols are smaller on wezterm, install a SYMBOLS ONLY
  -- nerd font https://www.nerdfonts.com/font-downloads so essentially the font
  -- loading becomes the following:
  -- font = wezterm.font_with_fallback {
  --   'Iosevka Custom Extended',
  --   'Symbols Nerd Font Mono',
  -- },
  font = wezterm.font {
    family = 'Iosevka Custom',
    stretch = 'Expanded',
    weight = 'Regular',
  },
  -- underscores can look weird depending on the font; see this issue:
  -- https://github.com/be5invis/Iosevka/issues/1361
  font_size = 15,
  warn_about_missing_glyphs = false,
  custom_block_glyphs = true,

  -- color options
  colors = SCHEME_OBJ,
  bold_brightens_ansi_colors = false,
  --> other nice themes
  -- color_scheme = 'Argonaut',
  -- color_scheme = 'Afterglow',
  -- BEWARE LIGHT MODE
  -- color_scheme = 'Catppuccin Latte',
  -- this looks cool but doesn't play nicely with indent-blankline
  force_reverse_video_cursor = false,

  -- tab options
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  hide_tab_bar_if_only_one_tab = false,

  -- application style
  background = {
    {
      source = {
        Color = SCHEME_OBJ.background,
      },
      opacity = 0.75,
      width = '100%',
      height = '100%',
    },
    {
      source = {
        File = 'Pictures/logo192.png',
      },
      vertical_align = 'Top',
      horizontal_align = 'Right',
      width = 160,
      height = 160,
      repeat_x = 'NoRepeat',
      repeat_y = 'NoRepeat',
      opacity = 0.25,
    },
  },
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  default_cursor_style = 'BlinkingBar',
  cursor_blink_rate = 500,
  animation_fps = 1,

  -- bindings
  keys = {
    {
      key = 'LeftArrow',
      mods = 'SHIFT',
      action = act.ActivateTabRelative(-1),
    },
    {
      key = 'RightArrow',
      mods = 'SHIFT',
      action = act.ActivateTabRelative(1),
    },
    {
      key = 'LeftArrow',
      mods = 'CTRL|SHIFT',
      action = act.MoveTabRelative(-1),
    },
    {
      key = 'RightArrow',
      mods = 'CTRL|SHIFT',
      action = act.MoveTabRelative(1),
    },
  },
  mouse_bindings = {
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.CompleteSelection('PrimarySelection'),
    },

    -- and make CTRL-Click open hyperlinks
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
    },

    -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
    {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.Nop,
    },
  },

  -- Linkify things that look like URLs with numeric addresses as hosts.
  -- E.g. http://127.0.0.1:8000 for a local development server,
  -- or http://192.168.1.1 for the web interface of many routers.
  hyperlink_rules = {
    {
      regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
      format = '$0',
    },
    -- Linkify things that look like URLs and the host has a TLD name.
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
      format = '$0',
    },

    -- linkify email addresses
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
      format = 'mailto:$0',
    },

    -- file:// URI
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = [[\bfile://\S*\b]],
      format = '$0',
    },
    -- linkify localhost links
    {
      regex = [[\bhttp[s]?://localhost:\d\d\d\d[/]?]],
      format = '$0',
    },
  },
}
