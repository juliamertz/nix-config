local wezterm = require('wezterm')
local M = {}

M.platform = {
  aarch64_apple_darwin = "aarch64-apple-darwin",
  x86_apple_darwin = "x86_64-apple-darwin",
  x86_linux_gnu = "x86_64-unknown-linux-gnu",
  x86_windows = "x86_64-pc-windows-msvc",
}

M.devices = {
  macos = M.platform.aarch64_apple_darwin,
  linux = M.platform.x86_linux_gnu
}

M.get = function(table)
  for key, value in pairs(table) do
    local platform = M.devices[key]
    if platform == wezterm.target_triple then
      return value
    end
  end
end

return M
