local wezterm = require("wezterm")
local M = {}

M.lookup_in_table = function(table, key)
	for _, v in pairs(table) do
		if v[1] == key then
			return v[2]
		end
	end
end

M.split = function(input, seperator)
	if seperator == nil then
		seperator = "%s"
	end
	local t = {}
	for str in string.gmatch(input, "([^" .. seperator .. "]+)") do
		table.insert(t, str)
	end
	return t
end

M.len = function(str_or_tbl)
	if type(str_or_tbl) == "table" then
		for i, _ in pairs(str_or_tbl) do
			return i
		end
	else
		return string.len(str_or_tbl)
	end
end

return M
