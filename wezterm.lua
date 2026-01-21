local wezterm = require("wezterm")
local act = wezterm.action
-- local mux = wezterm.mux

local config = wezterm.config_builder()
local unixPlatform = require("unix-platform")
local windowsPlatform = require("windows-platform")

-- UI
config.color_scheme = "Monokai Soda"
config.window_padding = {
	left = "1cell",
	right = "1cell",
	top = "20cell",
	bottom = "20cell",
}
-- config.font = wezterm.font("Fragment Mono")
-- config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font = wezterm.font("JetBrains Mono")
config.font_size = 12

-- UI.TabBar
config.use_fancy_tab_bar = false
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- config.window_decorations = "TITLE|RESIZE"
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.default_workspace = "main"
config.max_fps = 200

-- Keybinds and Leader
config.disable_default_key_bindings = true
config.leader = { key = "`", mods = "ALT", timeout_miliseconds = 3000 }

-- Platform specific implementations
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "powershell.exe" }
	windowsPlatform.apply_to_config(config)
else
	unixPlatform.apply_to_config(config)
end

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
	options = {
		icons_enabled = true,
		theme = "Monokai Remastered",
		color_overrides = {},
		section_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
		component_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = { "workspace" },
		tabline_c = { " " },
		tab_active = {
			"index",
			{ "parent", padding = 0 },
			"/",
			{ "cwd", padding = { left = 0, right = 1 } },
			{ "process", icons_only = true },
			-- process_to_icon = {
			-- 	["git"] = wezterm.nerdfonts.dev_git,
			-- },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
		tabline_x = {},
		tabline_y = { "datetime", "battery" },
		tabline_z = { "hostname" },
	},
	extensions = {},
})

tabline.apply_to_config(config)

-- local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
-- bar.apply_to_config(config, {
-- 	position = "bottom",
-- 	-- padding = {
-- 	-- 	top = 10,
-- 	-- },
-- })

-- config.keys = {
-- 	{ key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
-- 	{ key = "!", mods = "CTRL", action = act.ActivateTab(0) },
-- 	{ key = "s", mods = "LEADER|ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
-- 	{ key = "s", mods = "LEADER|SHIFT|ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
--
-- 	-- Tab Navigation
-- 	{ key = "Tab", mods = "LEADER|ALT", action = act.ActivateTabRelative(1) },
-- 	{ key = "Tab", mods = "LEADER|SHIFT|ALT", action = act.ActivateTabRelative(-1) },
-- 	{ key = "1", mods = "LEADER|ALT", action = act.ActivateTab(0) },
-- 	{ key = "2", mods = "LEADER|ALT", action = act.ActivateTab(1) },
-- 	{ key = "3", mods = "LEADER|ALT", action = act.ActivateTab(2) },
-- 	{ key = "4", mods = "LEADER|ALT", action = act.ActivateTab(3) },
-- 	{ key = "5", mods = "LEADER|ALT", action = act.ActivateTab(4) },
-- 	{ key = "6", mods = "LEADER|ALT", action = act.ActivateTab(5) },
-- 	{ key = "7", mods = "LEADER|ALT", action = act.ActivateTab(6) },
-- 	{ key = "8", mods = "LEADER|ALT", action = act.ActivateTab(7) },
-- 	{ key = "9", mods = "LEADER|ALT", action = act.ActivateTab(-1) },
-- 	--
-- 	{ key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
-- 	{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
-- 	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
-- 	{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
--
-- 	{ key = "f", mods = "CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
-- 	{ key = "f", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
-- 	-- { key = "H", mods = "CTRL", action = act.HideApplication },
-- 	{ key = "h", mods = "SUPER", action = act.HideApplication },
-- 	{
-- 		key = "l",
-- 		mods = "CTRL",
-- 		action = act.Multiple({
-- 			act.ClearScrollback("ScrollbackAndViewport"),
-- 			act.SendKey({ key = "L", mods = "CTRL" }),
-- 		}),
-- 	},
-- 	{
-- 		key = "l",
-- 		mods = "SUPER",
-- 		action = act.Multiple({
-- 			act.ClearScrollback("ScrollbackAndViewport"),
-- 			act.SendKey({ key = "L", mods = "CTRL" }),
-- 		}),
-- 	},
-- 	{
-- 		key = "c",
-- 		mods = "CTRL",
-- 		action = wezterm.action_callback(function(window, pane)
-- 			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
-- 			if has_selection then
-- 				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
--
-- 				window:perform_action(act.ClearSelection, pane)
-- 			else
-- 				window:perform_action(act.SendKey({ key = "c", mods = "CTRL" }), pane)
-- 			end
-- 		end),
-- 	},
-- 	{
-- 		key = "c",
-- 		mods = "SUPER",
-- 		action = wezterm.action_callback(function(window, pane)
-- 			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
-- 			if has_selection then
-- 				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
--
-- 				window:perform_action(act.ClearSelection, pane)
-- 			else
-- 				window:perform_action(act.SendKey({ key = "c", mods = "CTRL" }), pane)
-- 			end
-- 		end),
-- 	},
-- 	-- { key = "K", mods = "SHIFT|CTRL", action = act.ClearScrollback("ScrollbackOnly") },
-- 	{ key = "M", mods = "CTRL", action = act.Hide },
-- 	{ key = "m", mods = "SUPER", action = act.Hide },
-- 	{ key = "N", mods = "CTRL", action = act.SpawnWindow },
-- 	{ key = "n", mods = "SUPER", action = act.SpawnWindow },
-- 	{ key = "P", mods = "CTRL", action = act.ActivateCommandPalette },
-- 	{ key = "p", mods = "SUPER", action = act.ActivateCommandPalette },
-- 	{ key = "Q", mods = "CTRL", action = act.QuitApplication },
-- 	{ key = "q", mods = "SUPER", action = act.QuitApplication },
-- 	{ key = "r", mods = "SUPER", action = act.ReloadConfiguration },
-- 	-- { key = "R", mods = "LEADER|SHIFT|CTRL", action = act.ReloadConfiguration },
-- 	{ key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
-- 	-- { key = "T", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
-- 	{
-- 		key = "U",
-- 		mods = "CTRL",
-- 		action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
-- 	},
-- 	{
-- 		key = "U",
-- 		mods = "SHIFT|CTRL",
-- 		action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
-- 	},
-- 	-- { key = "W", mods = "SUPER", action = act.CloseCurrentPane({ confirm = true }) },
-- 	{ key = "w", mods = "SUPER", action = act.CloseCurrentPane({ confirm = true }) },
-- 	{ key = "w", mods = "LEADER|ALT", action = act.CloseCurrentPane({ confirm = true }) },
-- 	{ key = "x", mods = "CTRL", action = act.ActivateCopyMode },
-- 	{ key = "x", mods = "LEADER", action = act.ActivateCopyMode },
-- 	{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
--
-- 	{ key = "z", mods = "LEADER|ALT", action = act.TogglePaneZoomState },
-- 	{ key = "phys:Space", mods = "SHIFT|CTRL", action = act.QuickSelect },
-- 	{ key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
-- 	{ key = "PageUp", mods = "CTRL", action = act.ActivateTabRelative(-1) },
-- 	{ key = "PageUp", mods = "SHIFT|CTRL", action = act.MoveTabRelative(-1) },
-- 	{ key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
-- 	{ key = "PageDown", mods = "CTRL", action = act.ActivateTabRelative(1) },
-- 	{ key = "PageDown", mods = "SHIFT|CTRL", action = act.MoveTabRelative(1) },
-- 	{ key = "Copy", mods = "NONE", action = act.CopyTo("Clipboard") },
-- 	{ key = "Paste", mods = "NONE", action = act.PasteFrom("Clipboard") },
-- 	-- { key = "Z", mods = "SHIFT|CTRL", action = act.TogglePaneZoomState },
-- 	-- { key = "[", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(-1) },
-- 	-- { key = "]", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(1) },
-- 	-- { key = "^", mods = "CTRL", action = act.ActivateTab(5) },
-- 	-- { key = "^", mods = "SHIFT|CTRL", action = act.ActivateTab(5) },
-- 	-- { key = "_", mods = "CTRL", action = act.DecreaseFontSize },
-- 	-- { key = "_", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
-- 	-- { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
-- 	-- { key = "f", mods = "SHIFT|CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
-- 	-- { key = "f", mods = "SUPER", action = act.Search("CurrentSelectionOrEmptyString") },
-- 	-- { key = "h", mods = "SHIFT|CTRL", action = act.HideApplication },
-- 	-- { key = "h", mods = "SUPER", action = act.HideApplication },
-- 	-- { key = "k", mods = "SHIFT|CTRL", action = act.ClearScrollback("ScrollbackOnly") },
-- 	-- { key = "k", mods = "SUPER", action = act.ClearScrollback("ScrollbackOnly") },
-- 	-- { key = "m", mods = "SHIFT|CTRL", action = act.Hide },
-- 	-- { key = "m", mods = "SUPER", action = act.Hide },
-- 	-- { key = "n", mods = "SHIFT|CTRL", action = act.SpawnWindow },
-- 	-- { key = "n", mods = "SUPER", action = act.SpawnWindow },
-- 	-- { key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
-- 	-- { key = "q", mods = "SHIFT|CTRL", action = act.QuitApplication },
-- 	-- { key = "q", mods = "SUPER", action = act.QuitApplication },
-- 	-- { key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
-- 	-- { key = "t", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
-- 	-- { key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
-- 	{
-- 		key = "u",
-- 		mods = "SHIFT|CTRL",
-- 		action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
-- 	},
-- 	-- { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
-- 	-- { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
-- 	-- { key = "w", mods = "SHIFT|CTRL", action = act.CloseCurrentPane({ confirm = true }) },
-- 	-- { key = "w", mods = "SUPER", action = act.CloseCurrentPane({ confirm = true }) },
-- 	-- { key = "x", mods = "SHIFT|CTRL", action = act.ActivateCopyMode },
-- 	-- { key = "z", mods = "SHIFT|CTRL", action = act.TogglePaneZoomState },
-- 	-- { key = "{", mods = "SUPER", action = act.ActivateTabRelative(-1) },
-- 	-- { key = "{", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(-1) },
-- 	-- { key = "}", mods = "SUPER", action = act.ActivateTabRelative(1) },
-- 	-- { key = "}", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(1) },
-- 	-- { key = "h", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Left", 1 }) },
-- 	-- { key = "l", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Right", 1 }) },
-- 	-- { key = "k", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Up", 1 }) },
-- 	-- { key = "j", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Down", 1 }) },
-- }

-- smart_splits.apply_to_config(config)
smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- if you want to use separate direction keys for move vs. resize, you
	-- can also do this:
	-- direction_keys = {
	--   move = { 'h', 'j', 'k', 'l' },
	--   resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
	-- },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "ALT", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "ALT|LEADER", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
	-- log level to use: info, warn, error
	log_level = "info",
})

return config

-- spare keybinds
-- { key = "h", mods = "LEADER|ALT", action = act.ActivatePaneDirection("Left") },
-- { key = "l", mods = "LEADER|ALT", action = act.ActivatePaneDirection("Right") },
-- { key = "k", mods = "LEADER|ALT", action = act.ActivatePaneDirection("Up") },
-- { key = "j", mods = "LEADER|ALT", action = act.ActivatePaneDirection("Down") },
-- --
-- { key = "h", mods = "LEADER|ALT", action = act.AdjustPaneSize({ "Left", 1 }) },
-- { key = "l", mods = "LEADER|ALT", action = act.AdjustPaneSize({ "Right", 1 }) },
-- { key = "k", mods = "LEADER|ALT", action = act.AdjustPaneSize({ "Up", 1 }) },
-- { key = "j", mods = "LEADER|ALT", action = act.AdjustPaneSize({ "Down", 1 }) },

-- { key = "!", mods = "SHIFT|CTRL", action = act.ActivateTab(0) },
-- { key = 's', mods = "SHIFT|ALT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
-- { key = "#", mods = "LEADER|ALT", action = act.ActivateTab(2) },
-- { key = "#", mods = "SHIFT|CTRL", action = act.ActivateTab(2) },
-- { key = "$", mods = "CTRL", action = act.ActivateTab(3) },
-- { key = "$", mods = "LEADER|ALT", action = act.ActivateTab(3) },
-- { key = "%", mods = "CTRL", action = act.ActivateTab(4) },
-- { key = "%", mods = "LEADER|ALT", action = act.ActivateTab(4) },
-- { key = "s", mods = "SHIFT|ALT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
-- { key = "&", mods = "CTRL", action = act.ActivateTab(6) },
-- { key = "&", mods = "LEADER|ALT", action = act.ActivateTab(6) },
-- { key = "'", mods = "SHIFT|ALT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
-- { key = "(", mods = "CTRL", action = act.ActivateTab(-1) },
-- { key = "(", mods = "SHIFT|CTRL", action = act.ActivateTab(-1) },
-- { key = ")", mods = "CTRL", action = act.ResetFontSize },
-- { key = ")", mods = "SHIFT|CTRL", action = act.ResetFontSize },
-- { key = "*", mods = "CTRL", action = act.ActivateTab(7) },
-- { key = "*", mods = "SHIFT|CTRL", action = act.ActivateTab(7) },
-- { key = "+", mods = "CTRL", action = act.IncreaseFontSize },
-- { key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
-- { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
-- { key = "-", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
-- { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
-- { key = "0", mods = "CTRL", action = act.ResetFontSize },
-- { key = "0", mods = "SHIFT|CTRL", action = act.ResetFontSize },
-- { key = "0", mods = "SUPER", action = act.ResetFontSize },
-- { key = "1", mods = "SUPER", action = act.ActivateTab(0) },
-- { key = "2", mods = "SUPER", action = act.ActivateTab(1) },
-- { key = "3", mods = "SUPER", action = act.ActivateTab(2) },
-- { key = "4", mods = "SUPER", action = act.ActivateTab(3) },
-- { key = "5", mods = "SHIFT|ALT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
-- { key = "5", mods = "SUPER", action = act.ActivateTab(4) },
-- { key = "6", mods = "SUPER", action = act.ActivateTab(5) },
-- { key = "7", mods = "SUPER", action = act.ActivateTab(6) },
-- { key = "8", mods = "SUPER", action = act.ActivateTab(7) },
-- { key = "9", mods = "SUPER", action = act.ActivateTab(-1) },
-- { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
-- { key = "=", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
-- { key = "=", mods = "SUPER", action = act.IncreaseFontSize },
-- { key = "@", mods = "CTRL", action = act.ActivateTab(1) },
-- { key = "@", mods = "SHIFT|CTRL", action = act.ActivateTab(1) },
