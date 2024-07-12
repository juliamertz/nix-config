local utils = require("djor.utils")
local gears = require("gears")

---@class TextScroller
---@field public callback function
---@field public str string
---@field public max_width number
---@field public speed number
---@field public scroller function a function that returns a string, it is implied that this function will mutate the state of this class
---@field public state string?
---@field private timer timer?
local M = {
  max_width = 20,
  speed = 1,
}

---@protected
function M:_apply_config(config)
  self.max_width = config.max_width or self.max_width
  self.speed = config.speed or self.speed
  self.str = config.str or self.str
end

---@protected
function M:ensure_scroll_pos()
  if self.scroll_pos == nil then
    self.scroll_pos = 1
  end
end

---@param config table
function M:create(config)
  self:_apply_config(config)

  if not config.scroller then
    config.scroller = self.bounce_scroll
  end

  self:start(config.scroller, config.callback)

  return self
end

---@param scroller function
---@param callback function
---@return nil
function M:start(scroller, callback)
  if self.timer then
    self.timer:start()
    return
  end

  local timer = gears.timer({
    call_now = true,
    timeout = self.speed
  })

  timer:connect_signal("timeout", function()
    self.state = scroller(self)
    callback(self.state)
  end)

  timer:start()
  self.timer = timer
end

function M:stop()
  if self.timer then
    self.timer:stop()
  end
end

function M:bounce_scroll()
  self:ensure_scroll_pos()

  if self.scroll_pos >= #self.str - self.max_width then
    self.scroll_reverse = true
  end

  if self.scroll_pos <= 1 then
    self.scroll_reverse = false
  end

  if self.scroll_reverse then
    self.scroll_pos = self.scroll_pos - 1
  else
    self.scroll_pos = self.scroll_pos + 1
  end

  return self.str:sub(self.scroll_pos, self.scroll_pos + self.max_width)
end

function M:loop_scroll()
  self:ensure_scroll_pos()

  if self.scroll_pos >= #self.str - self.max_width then
    self.scroll_pos = 1
  else
    self.scroll_pos = self.scroll_pos + 1
  end

  return self.str:sub(self.scroll_pos, self.scroll_pos + self.max_width)
end

return M
