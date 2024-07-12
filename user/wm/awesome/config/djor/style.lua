local themes_path = require("gears.filesystem").get_themes_dir()
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local beautiful = require("beautiful")
local gears = require("gears")

local colors = require("plugins.rose-pine").moon

local theme = {
  font = "JetBrains Mono 12",
  wallpaper = "~/.config/background",

  bg_normal = colors.base,
  bg_focus = colors.surface,
  bg_urgent = colors.love,
  bg_minimize = colors.highlightLow,
  bg_systray = colors.base,

  fg_normal = colors.text,
  fg_focus = colors.pine,
  fg_urgent = colors.gold,
  fg_minimize = colors.highlightHigh,

  useless_gap = dpi(5),
  corner_radius = 15,
  systray_icon_spacing = dpi(5),
  border_width = dpi(3),
  border_normal = colors.highlightLow,
  border_focus = colors.love,
  border_marked = colors.gold,
}

local taglist_square_size = dpi(8)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)
theme.icon_theme = nil

local Wallpaper = {}

Wallpaper.images = { theme.wallpaper, }

function Wallpaper:init(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper

    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

return {
  theme = theme,
  colors = colors,
  wallpaper = Wallpaper,
}
