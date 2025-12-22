local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local tabline = wezterm.plugin.require 'https://github.com/michaelbrusegard/tabline.wez'

config.default_prog = { 'pwsh.exe' }
config.leader = { key = ' ', mods = 'CTRL' }

config.initial_rows = 40
config.initial_cols = 160
config.font_size = 11
config.font = wezterm.font 'Cascadia Code NF'
-- config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = 'Tokyo Night Storm'

config.window_background_opacity = 1.0

config.colors = {
  -- foreground = '#c5c9c5',
  -- background = '#1e1e1e',
  -- cursor_bg = '#ffffff',
  -- cursor_fg = '#000000',
  -- selection_bg = '#444444',
  -- selection_fg = '#ffffff',
  --
  -- -- ANSI colors
  -- ansi = {
  --   '#121214', -- black
  -- '#F05988', -- red
  -- '#32a852', -- lime
  -- '#FFCB67', -- yellow
  -- '#42a6f8', -- blue
  -- '#d66fd7', -- fuchsia
  -- '#4Ec9b2', -- aqua
  -- '#dcdcdc', -- white
  -- },
  --
  -- -- Bright ANSI colors
  -- brights = {
  --   '#2e2e2e', -- grey
  -- '#F05988', -- red
  -- '#32a852', -- lime
  -- '#FFCB67', -- yellow
  -- '#42a6f8', -- blue
  -- '#d66fd7', -- fuchsia
  -- '#4Ec9b2', -- aqua
  -- '#dcdcdc', -- white
  -- },

  background = '#292d3e',
  foreground = '#dcdcdc',
  cursor_bg = '#c5c9c5',
  cursor_fg = '#000000',
  selection_fg = '#5e5f61',
  selection_bg = '#444444',

  -- ANSI colors
  ansi = {
    '#1b1e2b', -- black
    '#f05988', -- maroon
    '#32a852', -- green
    '#ffcb67', -- olive
    '#42a6f8', -- navy
    '#d66fd7', -- purple
    '#4Ec9b2', -- teal
    '#dcdcdc', -- silver
  },

  -- Bright ANSI colors
  brights = {
    '#5e5f61', -- grey
    '#F05988', -- red
    '#32a852', -- lime
    '#FFCB67', -- yellow
    '#42a6f8', -- blue
    '#d66fd7', -- fuchsia
    '#4Ec9b2', -- aqua
    '#dcdcdc', -- white
  },
}

tabline.setup {
  options = {
    theme = config.colors,
  },
  sections = {
    tabline_a = {},
    tabline_b = {},
    tabline_c = { ' ' },
    tabline_x = { 'battery' },
    tabline_y = { 'datetime' },
    tabline_z = { 'hostname' },
    tab_active = {
      'index',
      -- { 'parent', padding = 0 },
      -- '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = {
      'index',
      -- { 'parent', padding = 0 },
      -- '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
  },
}
tabline.apply_to_config(config)

config.keys = {
  {
    key = 'Tab',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'Tab',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'F11',
    action = wezterm.action.ToggleFullScreen,
  },
  {
    key = 'c',
    mods = 'LEADER',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'q',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = 'a',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(0),
  },
  {
    key = 's',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(1),
  },
  {
    key = 'd',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(2),
  },
  {
    key = 'f',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(3),
  },
  {
    key = 'g',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(4),
  },
}

return config
