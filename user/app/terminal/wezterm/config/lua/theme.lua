local rose_pine = require("lua.rose-pine")
local palette = rose_pine.moon

local M = {}
M.palette = palette

local active_tab = {
  bg_color = palette.overlay,
  fg_color = palette.text,
}

local inactive_tab = {
  bg_color = palette.base,
  fg_color = palette.muted,
}

function M.colors()
  return {
    foreground = palette.text,
    background = palette.surface,
    cursor_bg = palette.muted,
    cursor_border = palette.muted,
    cursor_fg = palette.text,
    selection_bg = palette.overlay,
    selection_fg = palette.text,

    ansi = {
      palette.overlay,
      palette.love,
      palette.pine,
      palette.gold,
      palette.foam,
      palette.iris,
      palette.rose,
      palette.text,
    },

    brights = {
      palette.muted,
      palette.love,
      palette.pine,
      palette.gold,
      palette.foam,
      palette.iris,
      palette.rose,
      palette.text,
    },

    tab_bar = {
      background = palette.base,
      active_tab = active_tab,
      inactive_tab = inactive_tab,
      inactive_tab_hover = active_tab,
      new_tab = inactive_tab,
      new_tab_hover = active_tab,
      inactive_tab_edge = palette.muted,
    },
  }
end

function M.window_frame()
  return {
    active_titlebar_bg = palette.base,
    inactive_titlebar_bg = palette.base,
  }
end

return M
