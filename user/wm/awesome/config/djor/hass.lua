local utils = require("djor.utils")
local awful = require("awful")
local M = {}

---@parm direction string "next" or "previous"
---@return nil
M._cycle_scene = function(direction)
  assert(direction == "next" or direction == "previous", "direction must be 'next' or 'previous'")
  awful.util.spawn(utils.config_path() .. "scripts/home-assistant/cycleScenes.fish " .. direction)
end

M.next_scene = function()
  M._cycle_scene("next")
end

M.previous_scene = function()
  M._cycle_scene("previous")
end

return M
