local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

-- Volume -------------------------------------------

-- Volume update value ---
function update_volume()
	awful.spawn.easy_async({"sh", "-c", "amixer -D pipewire sget Master"}, function (stdout)
		local value = string.match(stdout, "(%d?%d?%d)%%")
		local muted = string.match(stdout, "%[(o%D%D?)%]")
		value = tonumber(value)
		local icon = ""
		if muted == "off" then
			icon = "󰖁 "
		elseif value <= 50 then
			icon = " "
		elseif value <= 100 then
			icon = "󰕾 "
		end
		awesome.emit_signal("volume::get_volume", value, icon)
	end)
end

-- Volume set value -----
awesome.connect_signal("volume::set_volume", function(set_volume)
	awful.spawn.easy_async({"sh", "-c", "amixer -D pipewire sset Master " .. set_volume}, function(stdout)
		update_volume()
	end)
end)

-- Update on start --
gears.timer {
    autostart = true,
    timeout = 1.5,
    callback = update_volume,
    single_shot = true -- one do callback and off
}
