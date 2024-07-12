local naughty = require("naughty")
local gears = require("gears")
local awful = require("awful")
local utils = require("djor.utils")
local wibox = require("wibox")

---@class SystemMonitorConfig
---@field update_interval number
---@field formatter function|nil
---@field prefix string
---@field unit string|nil
---@field initial_value string|nil
---@field preprocess function|nil
---@field cmd string

---@param config SystemMonitorConfig
---@return wibox.widget
local function create_sys_widget(config)
  config.update_interval = config.update_interval or 3
  config.unit = config.unit or "%"
  config.initial_value = config.initial_value or "0"

  local function format(str)
    local clean = utils.trim(str)
    local content = config.prefix .. clean .. config.unit

    if config.formatter then
      return config.formatter(content)
    end
    return content
  end

  local widget = wibox.widget({
    markup = format(config.initial_value),
    widget = wibox.widget.textbox
  })

  function widget:update()
    awful.spawn.easy_async_with_shell(config.cmd, function(stdout)
      local preprocessed = config.preprocess and config.preprocess(stdout) or stdout
      self:set_markup_silently(format(preprocessed))
    end)
  end

  function widget:start_polling()
    local timer = gears.timer({
      call_now = true,
      timeout = config.update_interval,
    })

    timer:connect_signal("timeout", function() ---@diagnostic disable-next-line: lowercase-global
      widget:update()
    end)

    timer:start()
  end

  widget:start_polling()
  return widget
end

---@class SystemMonitor
local M = {
  ---@type table
  config = {
    ---@type number
    update_interval = 3,
    ---@type function|nil
    formatter = nil,

    cpu_prefix = "CPU: ",
    gpu_prefix = "GPU: ",
    mem_prefix = "MEM: ",
  },
  create_sys_widget = create_sys_widget,
  widgets = {}
}

---@protected
---@param stdout string
function M:parse_cpu_usage(stdout)
  local _, user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
      stdout:match('(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)')

  local total = user + nice + system + idle + iowait + irq + softirq + steal

  local diff_idle = idle - tonumber(self.idle_prev == nil and 0 or self.idle_prev)
  local diff_total = total - tonumber(self.total_prev == nil and 0 or self.total_prev)
  local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

  self.total_prev = total
  self.idle_prev = idle

  return math.floor(diff_usage + 0.5)
end

function M:cpu_widget()
  return create_sys_widget({
    cmd = "grep --max-count=1 '^cpu.' /proc/stat",
    prefix = self.config.cpu_prefix,
    update_interval = self.config.update_interval,
    formatter = self.config.formatter,
    preprocess = function(stdout)
      return self:parse_cpu_usage(stdout)
    end
  })
end

function M:mem_widget()
  return create_sys_widget({
    cmd = [[free | grep Mem | awk '{print $3/$2 * 100.0}']],
    prefix = self.config.mem_prefix,
    update_interval = self.config.update_interval,
    formatter = self.config.formatter,
    preprocess = function(stdout)
      return math.floor(tonumber(stdout))
    end
  })
end

function M:gpu_widget()
  return create_sys_widget({
    cmd = [[nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{ print ""$1""}']],
    prefix = self.config.gpu_prefix,
    update_interval = self.config.update_interval,
    formatter = self.config.formatter
  })
end

function M:proton_vpn_widget()
  return create_sys_widget({
    cmd = "protonvpn-cli status",
    prefix = "VPN: ",
    unit = "",
    update_interval = self.config.update_interval,
    formatter = self.config.formatter,
    preprocess = function(stdout)
      return stdout
    end
  })
end

return M
