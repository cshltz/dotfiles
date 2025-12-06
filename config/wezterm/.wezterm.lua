local wezterm = require("wezterm")
local config = wezterm.config_builder()
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

config.default_prog = { "pwsh.exe" }
config.leader = { key = " ", mods = "CTRL" }

config.initial_rows = 40
config.initial_cols = 160
config.font_size = 12
-- config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("Cascadia Code NF")

config.colors = {
	foreground = "#c5c9c5",
	background = "#1e1e1e",
	cursor_bg = "#ffffff",
	cursor_fg = "#000000",
	selection_bg = "#444444",
	selection_fg = "#ffffff",

	-- ANSI colors (black, red, green, yellow, blue, magenta, cyan, white)
	ansi = {
		"#1e1e1e", -- black
		"#FF7680", -- maroon
		"#32a852", -- green
		"#98C279", -- olive
		"#42A6F8", -- navy
		"#8A7DFF", -- purple
		"#4EC9B2", -- teal
		"#999999", -- silver
	},

	-- Bright ANSI colors
	brights = {
		"#555555", -- grey
		"#F05988", -- red
		"#43e870", -- lime
		"#FFCB67", -- yellow
		"#9CDCFE", -- blue
		"#C28894", -- fuchsia
		"#4EC9B2", -- aqua
		"#ffffff", -- white
	},
}

tabline.setup({
	options = {
		-- theme = "Catppuccin Mocha",
		theme = config.colors,
	},
	sections = {
		tabline_b = {},
		tabline_x = {},
		tabline_y = { "datetime" },
		tabline_z = { "hostname" },
	},
})
tabline.apply_to_config(config)

config.keys = {
	{
		key = "F11",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "a",
		mods = "LEADER",
		action = wezterm.action.ActivateTab(0),
	},
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action.ActivateTab(1),
	},
	{
		key = "d",
		mods = "LEADER",
		action = wezterm.action.ActivateTab(2),
	},
	{
		key = "f",
		mods = "LEADER",
		action = wezterm.action.ActivateTab(3),
	},
	{
		key = "g",
		mods = "LEADER",
		action = wezterm.action.ActivateTab(4),
	},
}

return config
