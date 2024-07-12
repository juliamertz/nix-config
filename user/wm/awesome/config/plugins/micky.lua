--- https://github.com/basaran/awesomewm-micky/blob/master/init.lua
local gears = require('gears')
local stay_classes = {
  awesome
}

local function set_contains(set, key)
  return set[key] ~= nil
end

local micky = function()
  gears.timer.weak_start_new(0.05, function()
    local c = client.focus
    local cgeometry = c:geometry()

    mouse.coords({
      x = cgeometry.x + cgeometry.width / 2,
      y = cgeometry.y + cgeometry.height / 2
    })
  end)
end

client.connect_signal("focus", function(c)
  local focused_client = c

  gears.timer.weak_start_new(0.15, function()
    local client_under_mouse = mouse.current_client
    local should_stay = set_contains(stay_classes, client_under_mouse.class)

    if should_stay then return false end

    if not client_under_mouse then
      micky()
      return false
    end

    if focused_client:geometry().x ~= client_under_mouse:geometry().x
        or focused_client:geometry().y ~= client_under_mouse:geometry().y
    then
      micky()
      return false
    end
  end)
end)

client.connect_signal("unmanage", function(c)
  local client_under_mouse = mouse.current_client

  if not client_under_mouse then
    return false
  end

  if client_under_mouse ~= c then
    micky()
  end
end)

return micky
