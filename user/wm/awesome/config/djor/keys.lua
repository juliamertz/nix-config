local style = require("djor.style")
local utils = require("djor.utils")
local bar = require("djor.bar")
local gears = require("gears")
local awful = require("awful")
local launch = require("djor.launch")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local home_assistant = require("djor.hass")

local modkey = "Mod4"
local M = {
	modkey = modkey,
	tags_per_screen = 4,
	screens_by_index = {},
}

M.globalkeys = gears.table.join(
	-- awful.key({ modkey, "Shift" }, "s", hotkeys_popup.show_help,
	--   { description = "show help", group = "awesome" }),
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),

	awful.key({ modkey }, "s", function()
		local focused = awful.screen.focused()
		if focused.index == 1 then
			awful.screen.focus(2)
		else
			awful.screen.focus(1)
		end
	end, { description = "show screen index", group = "screen" }),

	-- Media keys
	awful.key({}, "XF86AudioPlay", function()
		awful.util.spawn("playerctl play-pause")
	end),
	awful.key({}, "XF86AudioNext", function()
		awful.util.spawn("playerctl next")
	end),
	awful.key({}, "XF86AudioPrev", function()
		awful.util.spawn("playerctl previous")
	end),
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.util.spawn("pamixer --increase 5")
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.util.spawn("pamixer --decrease 5")
	end),
	awful.key({}, "XF86AudioMute", function()
		awful.util.spawn("pamixer --toggle-mute")
	end),
	awful.key(
		{ modkey },
		"Prior",
		home_assistant.next_scene,
		{ description = "Cycle to next light scene", group = "client" }
	),
	awful.key(
		{ modkey },
		"Next",
		home_assistant.previous_scene,
		{ description = "Cycle to previous light scene", group = "client" }
	),

	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey, "Shift" }, "s", function()
		local focused = awful.screen.focused()
		if client.focus then
			if focused.index == 1 then
				client.focus.screen = 2
				awful.screen.focus(2)
			else
				client.focus.screen = 1
				awful.screen.focus(1)
			end
		end
	end, { description = "Send client to unfocused display", group = "client" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),
	awful.key({ modkey, "Shift" }, "b", function()
		awful.spawn("blueman-manager")
	end, { description = "open bluetooth menu", group = "launcher" }),
	awful.key({ modkey }, "Return", function()
		launch.apps.terminal:focus()
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "m", function()
		awful.spawn([[alacritty --hold -e spotify_player]])
	end, { description = "open music player", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "w", function()
		launch.apps.browser:focus()
	end, { description = "open browser", group = "launcher" }),
	awful.key({ modkey }, "space", function()
		awful.spawn(launch.rofi.launcher)
	end, { description = "open launcher", group = "launcher" }),
	awful.key({ modkey }, "Print", function()
		awful.spawn([[scrot -M 0 -F "/home/joris/screenshots/$(date | tr ' ' '-').png"]])
	end, { description = "open launcher", group = "launcher" }),
	awful.key({}, "Print", function()
		awful.spawn(launch.rofi.screenshotmenu)
	end, { description = "open screenshotmenu", group = "launcher" }),
	awful.key({ modkey }, "Home", function()
		awful.spawn(launch.rofi.displaymenu)
	end, { description = "open dispaymenu", group = "launcher" }),
	awful.key({ modkey }, "o", function()
		awful.spawn(launch.rofi.audiomenu)
	end, { description = "open audiomenu", group = "launcher" }),
	awful.key({ modkey }, "End", function()
		awful.spawn(launch.rofi.powermenu)
	end, { description = "open powermenu", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "o", function()
		awful.spawn(utils.config_path() .. "scripts/toggle-airpods-connection.sh")
	end, { description = "connect airpods", group = "launcher" }),

	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ modkey }, "r", function()
		awful.screen.focused().prompt_box:run()
	end, { description = "run prompt", group = "launcher" }),

	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().prompt_box.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),
	-- Menubar
	awful.key({ modkey }, "p", function()
		menubar.show()
	end, { description = "show the menubar", group = "launcher" })
)

M.clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey }, "w", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ modkey }, "b", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	-- awful.key({ Modkey, }, "b", function(c) c:move_to_screen() end,
	--   { description = "move to screen", group = "client" }),
	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),
	awful.key({ modkey }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "minimize", group = "client" }),
	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized

		c:raise()
	end, { description = "(un)maximize", group = "client" }),
	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "client" })
	-- awful.key({ modkey, "Shift" }, "m",
	--   function(c)
	--     c.maximized_horizontal = not c.maximized_horizontal
	--     c:raise()
	--   end,
	--   { description = "(un)maximize horizontally", group = "client" })
)

for s in screen do
	table.insert(M.screens_by_index, s)
end

---@param tag_index integer
local function get_screen_index(tag_index)
	if tag_index <= M.tags_per_screen then
		return 1
	else
		return 2
	end
end

-- Looks up the relative tag index based on the tags per screen.
-- For example when there are 4 tags per screen, the first tag on the second screen will be 5.
---@param tag integer
---@return tag
local function get_relative_tag(tag)
	local s = get_screen_index(tag)
	local idx = tag - M.tags_per_screen * (s - 1)
	return M.screens_by_index[s].tags[idx]
end

for i = 1, M.tags_per_screen * 2 + 1 do
	M.globalkeys = gears.table.join(
		M.globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 8, function()
			local tag = get_relative_tag(i - 1)

			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),

		awful.key({ modkey, "Control" }, "#" .. i + 8, function()
			local tag = get_relative_tag(i - 1)

			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),

		awful.key({ modkey, "Shift" }, "#" .. i + 8, function()
			if client.focus then
				local tag = get_relative_tag(i - 1)

				if tag then
					client.focus:move_to_tag(tag)
					tag:view_only()
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 8, function()
			if client.focus then
				local tag = client.focus.screen.tags[i - 1]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

-- this one is broken, bar is undefined here. fix later :)
root.buttons(gears.table.join(awful.button({}, 3, function()
	bar.main_menu:toggle()
end)))

M.clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

root.keys(M.globalkeys)

return M
