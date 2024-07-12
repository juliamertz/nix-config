local wezterm = require("wezterm")
local utils = require("lua.utils")
local rosepine = require("lua.theme")
local os = require("lua.os")
local keys = require("lua.keys")
local act = wezterm.action

local config = {
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_size = os.get({ linux = 22.0, macos = 14.0 }),
	max_fps = os.get({ linux = 165, macos = 60 }),
	colors = rosepine.colors(),
	window_frame = rosepine.window_frame(),
	window_background_opacity = 0.75,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,
	keys = keys.value,
}

config.leader = { key = "a", mods = "ALT", timeout_milliseconds = 2000 }

keys.mod("LEADER|CTRL", {
	{ key = "c", action = act({ SpawnTab = "CurrentPaneDomain" }) },
})

keys.mod("LEADER", {
	{ key = "i", action = act.ShowDebugOverlay },
	{ key = "c", action = act({ CloseCurrentPane = { confirm = false } }) },
	{ key = "s", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "z", action = act.TogglePaneZoomState },
	{ key = "r", action = act.ShowLauncher },
})

keys.builtins.adjustPaneSize("CTRL|ALT", 5)
keys.builtins.activatePaneDirection("SHIFT|ALT")
keys.builtins.activateTab("ALT", 1, 8)

local max_title_length = 16
local title_padding = 1

local function center_title(title)
	local padding = (max_title_length - title_padding * 2) - utils.len(title)
	local left_padding = math.floor(padding / 2)
	local right_padding = math.ceil(padding / 2)

	return string.rep(" ", left_padding) .. title .. string.rep(" ", right_padding)
end

local function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end

	local split = utils.split(tab_info.active_pane.title, " ")
	return string.sub(split[1], 1, max_title_length - title_padding * 2)
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title(tab)
	if tab.is_active then
		return {
			{ Text = center_title(title) },
			{ Background = { Color = rosepine.palette.overlay } },
		}
	else
		return {
			{ Text = center_title(title) },
		}
	end
end)

return config
