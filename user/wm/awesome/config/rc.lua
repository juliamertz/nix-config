-- pcall(require, "luarocks.loader")

local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local utils = require("djor.utils")
local awful = require("awful")
local beautiful = require("beautiful")
local bar = require("djor.bar")
local style = require("djor.style")
local keys = require("djor.keys")
local launch = require("djor.launch")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

require("djor.errors")
require("djor.keys")

beautiful.init(style.theme)

awful.layout.layouts = {
	awful.layout.suit.tile.left, -- Used for main horizontal display
	awful.layout.suit.tile.bottom, -- Used for second vertical display
}

local layout_master_width_factors = {
	0.7,
	0.68,
}

local tags = {
	"TERM",
	"WEB",
}

local screen_idx = 1
awful.screen.connect_for_each_screen(function(s)
	for i = 1, 4 do
		local tag_idx = (screen_idx - 1) * 4 + i
		local tag_name = tags[i] or tostring(tag_idx)

		awful.tag.add(tag_name, {
			screen = s,
			layout = awful.layout.layouts[screen_idx],
			master_width_factor = layout_master_width_factors[screen_idx],
			selected = i == 1,
		})
	end

	style.wallpaper:init(s)
	if screen_idx == 1 then
		bar.init(s)
	end

	screen_idx = screen_idx + 1
end)

awful.rules.rules = {
	{
		rule = {},
		callback = awful.client.setslave,
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = keys.clientkeys,
			buttons = keys.clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	{
		rule_any = {
			instance = {},
			class = {
				"Arandr",
				"feh",
			},
			name = {
				"Event Tester",
			},
			role = {
				"pop-up",
			},
		},
		properties = {
			placement = awful.placement.centered,
			floating = true,
		},
	},

	{
		rule = { class = "Alacritty" },
		callback = function(c)
			c.floating = true
			c.width = 1600
			c.height = 1000
			awful.placement.centered(c, { honor_workarea = true, honor_padding = true })
		end,
	},

	{
		rule = { class = launch.apps.terminal.class },
		properties = { screen = 1, tag = "TERM" },
	},
	-- {
	--   rule = { class = launch.apps.browser.class },
	--   properties = { screen = 1, tag = "WEB" }
	-- },
	{
		rule = { class = launch.apps.music.class },
		properties = { screen = 1, tag = "3" },
	},
	{
		rule = { class = launch.apps.browser.class },
		callback = function(c)
			local has_browser = false
			local tag = screen.primary.tags[2]

			for _, client in ipairs(tag:clients()) do
				if client.class == launch.apps.browser.class then
					has_browser = true
					break
				end
			end

			if not has_browser then
				c:move_to_tag(tag)
			end
		end,
	},
}

local function set_corner_radius(client)
	if client.maximized then
		client.shape = utils.corner_radius(0)
		client.border_width = dpi(0)
	else
		client.shape = utils.corner_radius(style.theme.corner_radius)
		client.border_width = style.theme.border_width
	end
end

-- Corner rounding
client.connect_signal("manage", set_corner_radius)
client.connect_signal("property::maximized", set_corner_radius)

-- Mouse follows focus
require("plugins.micky")

-- Focus follows mouse
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)
screen.connect_signal("property::geometry", style.wallpaper.init)

awful.spawn.with_shell("~/.config/awesome/autorun.sh")
