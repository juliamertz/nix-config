local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local launch = require("djor.launch")
local utils = require("djor.utils")

local M = {}

M.awesome_menu = {
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "restart", awesome.restart },
  { "quit",    awesome.quit },
}

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
        "request::activate",
        "tasklist",
        { raise = true }
      )
    end
  end),
  awful.button({}, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end))


M.main_menu = awful.menu({
  items = {
    { "awesome",       M.awesome_menu,      beautiful.awesome_icon },
    { "open terminal", launch.apps.terminal }
  }
})

M.launcher = awful.widget.launcher({
  image = utils.config_path() .. "awesome/icons/nixos.png",
  menu = M.main_menu
})

menubar.utils.terminal = launch.apps.terminal

local colors = require('djor.style').colors
local date_format = utils.html_text_style("%Y/%m/%d %H:%M:%S", colors.gold)
local clock = wibox.widget.textclock(date_format, 1)

local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end)
)

local function song_format(str)
  return utils.html_text_style("󰎈 " .. str, colors.foam, nil, true)
end

local function sys_format(str)
  return utils.html_text_style(str, colors.iris, nil, true)
end

local system = require('plugins.system')
system.config.formatter = sys_format

local cpu = system:cpu_widget()
local mem = system:mem_widget()
local gpu = system:gpu_widget()
local vpn = system:proton_vpn_widget()

-- local spotify = require('plugins.spotify')
-- local spotify_widget = spotify:widget({
--   formatter = song_format,
--   scroll = {
--     type = spotify.scrollers.bounce_scroll,
--     enabled = true,
--     speed = 0.5,
--     max_width = 30
--   },
-- })

M.init = function(s)
  s.prompt_box = awful.widget.prompt()

  s.layout_box = awful.widget.layoutbox(s)
  s.layout_box:buttons(gears.table.join(
    awful.button({}, 1, function() awful.layout.inc(1) end),
    awful.button({}, 3, function() awful.layout.inc(-1) end),
    awful.button({}, 4, function() awful.layout.inc(1) end),
    awful.button({}, 5, function() awful.layout.inc(-1) end)
  ))

  s.tag_list = awful.widget.taglist({
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
  })

  s.mywibox = awful.wibar({ position = "top", opacity = 0.8, screen = s })

  s.mytasklist = awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons
  }
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    expand = "none",
    {
      layout = wibox.layout.align.horizontal,
      M.launcher,
      s.tag_list,
      -- s.mytasklist,
      s.prompt_box,
    },
    {
      layout = wibox.layout.align.horizontal,
      clock,
    },
    {
      layout = wibox.layout.align.horizontal,
      wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        spacing = 20,
        cpu,
        gpu,
        mem,
        -- spotify_widget,
      },
      wibox.layout.margin(wibox.widget.systray(), 10, 10, 10, 10),
      -- s.layout_box,
    },
  }
end

return M
