local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

-- Volume -------------------------------------------

-- Volume update value ---
function update_volume()
	awful.spawn.easy_async({ "sh", "-c", "amixer -D pipewire sget Master" }, function(stdout)
		local value = string.match(stdout, "(%d?%d?%d)%%")
		local muted = string.match(stdout, "%[(o%D%D?)%]")
		value = tonumber(value)
		awesome.emit_signal("volume::get_volume", value, muted)
	end)
end

-- Volume set value -----
awesome.connect_signal("volume::set_volume", function(set_volume)
	awful.spawn.easy_async({ "sh", "-c", "amixer -D pipewire sset Master " .. set_volume }, function(stdout)
		update_volume()
	end)
end)
