local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local tabline = wezterm.plugin.require 'https://github.com/michaelbrusegard/tabline.wez'
local theme = require 'theme'

local default_theme = theme.default_theme
local tabline_theme = theme.copy(default_theme)

config.default_prog = { 'pwsh.exe' }
config.leader = { key = ' ', mods = 'CTRL' }

config.initial_rows = 40
config.initial_cols = 160
config.font_size = 11
config.font = wezterm.font 'Cascadia Code NF'
-- config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = 'Tokyo Night Storm'

config.window_background_opacity = 1.0

config.colors = theme.copy(default_theme)

tabline.setup {
  options = {
    theme = tabline_theme,
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

wezterm.on('cycle-theme', function(window)
  local name = theme.next_name()
  local palette = theme.load(name)
  for key, value in pairs(palette) do
    tabline_theme[key] = value
  end
  tabline.set_theme()

  local overrides = window:get_config_overrides() or {}
  overrides.colors = theme.copy(name)
  overrides.colors.tab_bar = { background = tabline.get_theme().normal_mode.c.bg }
  window:set_config_overrides(overrides)
  wezterm.log_info('active theme: ' .. name)
end)

config.keys = {
  {
    key = 'Tab',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'h',
    mods = 'CTRL',
    action = wezterm.action.SendKey {
      key = 'h',
      mods = 'CTRL',
    },
  },
  {
    key = 'Tab',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 't',
    mods = 'LEADER',
    action = wezterm.action.EmitEvent 'cycle-theme',
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
