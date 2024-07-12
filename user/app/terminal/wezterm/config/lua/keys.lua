local wezterm = require("wezterm")
local M = {}

M.value = {}
M.builtins = {}

M.mod = function(mods, keys)
	for _, entry in ipairs(keys) do
		table.insert(M.value, {
			key = entry.key,
			mods = mods,
			action = entry.action,
		})
	end
end

M.mod_group = function(opts)
	for i, key in ipairs(opts.keys) do
		table.insert(M.value, {
			key = key,
			mods = opts.mods,
			action = opts.action(opts.actions[i]),
		})
	end
end

M.builtins.adjustPaneSize = function(mods, size)
	M.mod_group({
		mods = mods,
		keys = { "h", "j", "k", "l" },
		actions = { "Left", "Down", "Up", "Right" },
		action = function(direction)
			return wezterm.action.AdjustPaneSize({ direction, size or 5 })
		end,
	})
end

M.builtins.activatePaneDirection = function(mods)
	M.mod_group({
		mods = mods,
		keys = { "h", "j", "k", "l" },
		actions = { "Left", "Down", "Up", "Right" },
		action = function(direction)
			return wezterm.action.ActivatePaneDirection(direction)
		end,
	})
end

M.builtins.activateTab = function(mods, start, finish)
	for i = start, finish do
		table.insert(M.value, {
			key = tostring(i),
			mods = mods,
			action = wezterm.action.ActivateTab(i - 1),
		})
	end
end

return M
