local utils = require("djor.utils")
local bling = require("plugins.bling")
local scroller = require("plugins.text-scroller")
local wibox = require("wibox")
local playerctl = bling.signal.playerctl.lib()

---@class SpotifyScroller
---@field public enabled boolean
---@field public type function? Scroller type, all types are exported under `scrollers` field
---@field public speed number
---@field public max_width number
---@field public _scroller TextScroller?

---@class Spotify
---@field public formatter function?
---@field public scroll SpotifyScroller
local M = {
	formatter = nil,
	scroll = {
		enabled = true,
		type = nil,
		speed = 1,
		max_width = 30,

		_scroller = nil,
	},

	scrollers = {
		bounce_scroll = scroller.bounce_scroll,
	},

	state = {
		title = nil,
		artist = nil,
		album = nil,
		playing = nil,
	},
}

---@param state table
function M:format_status(state)
	if not state.title or not state.artist then
		local msg = "No song playing"
		if self.formatter then
			return self.formatter(msg)
		end
		return msg
	end

	return state.title .. " - " .. state.artist
end

---@protected
---@param opts table|nil
---@return nil
function M:apply_config(opts)
	if not opts then
		return
	end

	if opts.scroll ~= nil then
		self.scroll.enabled = opts.scroll.enabled
		self.scroll.speed = opts.scroll.speed
		self.scroll.max_width = opts.scroll.max_width
	end

	if opts.formatter then
		self.formatter = opts.formatter
	end
end

---@param content string
---@param callback function
---@return nil
function M:create_scroller(content, callback)
	if #content > self.scroll.max_width and self.scroll.enabled then
		self.scroll._scroller = scroller:create({
			str = content,
			max_width = self.scroll.max_width,
			speed = self.scroll.speed,
			scroller = scroller.bounce_scroll,
			callback = callback,
		})
	else
		self.scroll._scroller = nil
		callback(content)
	end
end

---@param opts Spotify
---@return wibox.widget
function M:widget(opts)
	M:apply_config(opts)

	local widget = wibox.widget({
		markup = M:format_status({}),
		widget = wibox.widget.textbox,
	})

	playerctl:connect_signal("metadata", function(_, title, artist, _, album, new, player_name)
		if player_name ~= "spotify_player" then
			return
		end

		self.state = {
			title = title,
			artist = artist,
			album = album,
			playing = new,
		}

		if self.scroll._scroller then
			self.scroll._scroller:stop()
		end

		self:create_scroller(self:format_status(self.state), function(str)
			if self.formatter then
				str = self.formatter(str)
			end

			widget:set_markup_silently(str)
		end)
	end)

	return widget
end

return M
